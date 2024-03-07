class Api::V1::ProductsController < ApplicationController
  def index
    @products = Product.order(created_at: :desc)
  end

  def search 
    product_name = params[:product_name]
    min_price_in_cents = params[:min_price_in_cents]&.to_i  # Convert to integer if present
    max_price_in_cents = params[:max_price_in_cents]&.to_i  # Convert to integer if present
    date_posted_start = params[:date_posted_start]&.to_date  # Convert to date if present
    date_posted_end = params[:date_posted_end]&.to_date  # Convert to date if present
  
    query = Product.all
  
    query_by_name = query.where(name: product_name) if product_name.present?
    query_by_price_range = query.where(price: min_price_in_cents..max_price_in_cents) if min_price_in_cents && max_price_in_cents
    query_by_date_range = query.where(created_at: date_posted_start..date_posted_end) if date_posted_start && date_posted_end
    
    if query_by_name.empty? && query_by_price_range.empty? && query_by_date_range.empty?
      render json: { status: 404, body: 'No results from query, please try your search again.' }
    else
      rener json: { 
        status: 200, 
        body: { 
          query_by_name: query_by_name, 
          query_by_price_range: query_by_price_range, 
          query_by_date_range: query_by_date_range 
        }
      }
    end
  end

  def create
    product_params = params.require(:product).permit(:name, :price_in_cents, :description)
    @product = Product.new(product_params)
  
    if @product.save
      if @product.price_in_cents > 500000
        approval_queue << @product
      end
      render json: { status: 200, body: 'Product created successfully.' }
    else
      render json: { status: 400, body: "Product creation failed: #{@product.errors.full_messages.join(', ')}" }
    end
  end

  def update
    @product = Product.find(params[:id])
    previous_price = @product.price_in_cents

    product_params = params.require(:product).permit(:name, :price_in_cents, :description)
  
    if @product.update(product_params)
      if (@product.price_in_cents / previous_price) > 1.5
        approval_queue << @product
      end
      render json: { status: 200, body: 'Product updated successfully.' }
    else
      render json: { status: 400, body: "Product update failed: #{@product.errors.full_messages.join(', ')}" }
    end
  end

  def destroy
    @product = Product.find(params[:id])
    # append to queue before deletion
    approval_queue << @product

    @product.destroy
    if @product.destroyed?
      render json: { status: 200, body: "Product deleted successfully." }
    else
      render json: { status: 400, body: "Product deletion failed: #{@product.errors.full_messages.join(', ')}" }
    end
  end

  def approval_queue_index 
    @products_descending = approval_queue.sort_by { |product| -product[:created_at] }

    if approval_queue.empty?
      render json: { status: 404, body: 'No products in the queue at this time.'}
    else
      render json: { status: 200, body: @products_descending }
    end
  end

  def approve_product 
    @product = Product.find(params[:id])

    if @product.status == false
      @product.status = true 
    end

    remove_product_from_approval_queue
  end

  def reject_product
    remove_product_from_approval_queue
  end

  private

  def approval_queue 
    @approval_queue = []
  end

  def remove_product_from_approval_queue
    approval_queue.delete_if {|product| product[:id] == params[:id] }
  end
end
