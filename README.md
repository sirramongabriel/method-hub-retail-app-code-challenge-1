# Products Controller Documentation

## Introduction
The ProductsController manages products in the application, providing endpoints for CRUD operations & managing product approval.

## Endpoints

### `GET /api/v1/products`
- **Description:** Retrieves all products sorted by creation date in descending order.
- **Response:**
  - Status Code: 200 OK
  - Body: JSON array of products
  - Status Code: 404 Not Found (if no products found)

### `POST /api/v1/products/search`
- **Description:** Searches for products based on specified criteria.
- **Parameters:**
  - `product_name` (string): Name of the product.
  - `min_price_in_cents` (integer): Minimum price of the product in cents.
  - `max_price_in_cents` (integer): Maximum price of the product in cents.
  - `date_posted_start` (date): Start date of the posting period.
  - `date_posted_end` (date): End date of the posting period.
- **Response:**
  - Status Code: 200 OK
  - Body: JSON object containing the search results
  - Status Code: 404 Not Found (if no results found)

### `POST /api/v1/products`
- **Description:** Creates a new product.
- **Parameters:**
  - `name` (string): Name of the product.
  - `price_in_cents` (integer): Price of the product in cents.
  - `description` (string): Description of the product.
- **Response:**
  - Status Code: 200 OK (if successful)
  - Body: JSON object with message: "Product created successfully."
  - Status Code: 400 Bad Request (if creation fails)
  - Body: JSON object with message: "Product creation failed: [error messages]"

### `PUT /api/v1/products/:id`
- **Description:** Updates an existing product.
- **Parameters:** Same as `POST /api/v1/products`.
- **Response:**
  - Status Code: 200 OK (if successful)
  - Body: JSON object with message: "Product updated successfully."
  - Status Code: 400 Bad Request (if update fails)
  - Body: JSON object with message: "Product update failed: [error messages]"

### `DELETE /api/v1/products/:id`
- **Description:** Deletes a product.
- **Response:**
  - Status Code: 200 OK (if successful)
  - Body: JSON object with message: "Product deleted successfully."
  - Status Code: 400 Bad Request (if deletion fails)
  - Body: JSON object with message: "Product deletion failed: [error messages]"

### `GET /api/v1/products/approval_queue`
- **Description:** Retrieves products pending approval.
- **Response:**
  - Status Code: 200 OK
  - Body: JSON array of products in the approval queue
  - Status Code: 404 Not Found (if no products in the queue)
  - Body: JSON object with message: "No products in the queue at this time."

### `POST /api/v1/products/:id/approve`
- **Description:** Approves a product pending approval.
- **Response:**
  - Status Code: 200 OK (if successful)
  - Body: JSON object with message: "Product approved successfully."
  - Status Code: 400 Bad Request (if approval fails)
  - Body: JSON object with message: "Product approval failed."

### `POST /api/v1/products/:id/reject`
- **Description:** Rejects a product pending approval.
- **Response:**
  - Status Code: 200 OK (if successful)
  - Body: JSON object with message: "Product rejected successfully."
  - Status Code: 400 Bad Request (if rejection fails)
  - Body: JSON object with message: "Product rejection failed."