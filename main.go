package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
)

// Product представляет продукт
type Product struct {
	ID          int
	ImageURL    string
	Title       string
	Description string
	Price       int
	Indicator   int
	IsFavorite  bool
}

// Item представляет элемент корзины
type Item struct {
	ID      int
	Counter int
}

var basket = []Item{}

var products = []Product{
	{
		ID:          1,
		Title:       "Грузовик С200",
		ImageURL:    "https://o-m-z.ru/images/ural/Ural_4320_pic_62276.jpg",
		Description: "«Трак грузовой",
		Price:       299000,
		Indicator:   1,
		IsFavorite:  false,
	},
	{
		ID:          2,
		Title:       "Грузовик С800",
		ImageURL:    "https://o-m-z.ru/media/k2/items/cache/ea91bb19891b6c623322a2cb25533741_L.jpg",
		Description: "Грузовик БК",
		
		Price:       449000,
		Indicator:   1,
		IsFavorite:  false,
	},
	
}

// обработчик для GET-запроса, возвращает список продуктов
func getProductsHandler(w http.ResponseWriter, r *http.Request) {
	// Устанавливаем заголовки для правильного формата JSON
	w.Header().Set("Content-Type", "application/json")
	// Преобразуем список заметок в JSON
	json.NewEncoder(w).Encode(products)
}

// Функция вычисления нового ID продукта
func getNextID(products []Product) int {
	maxID := 0
	for _, product := range products {
		if product.ID > maxID {
			maxID = product.ID
		}
	}
	return maxID + 1
}

// Обработчик для POST-запроса, добавляет продукт
func createProductHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
		return
	}

	var newProduct Product
	err := json.NewDecoder(r.Body).Decode(&newProduct)
	if err != nil {
		fmt.Println("Error decoding request body:", err)
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	fmt.Printf("Received new Product: %+v\n", newProduct)

	newProduct.ID = getNextID(products)
	products = append(products, newProduct)

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(newProduct)
}

// Добавление маршрута для получения одного продукта

func getProductByIDHandler(w http.ResponseWriter, r *http.Request) {
	// Получаем ID из URL
	idStr := r.URL.Path[len("/Products/"):]
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid Product ID", http.StatusBadRequest)
		return
	}

	// Ищем продукт с данным ID
	for _, Product := range products {
		if Product.ID == id {
			w.Header().Set("Content-Type", "application/json")
			json.NewEncoder(w).Encode(Product)
			return
		}
	}

	// Если продукт не найден
	http.Error(w, "Product not found", http.StatusNotFound)
}

// Удаление продукта по id
func deleteProductHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodDelete {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
		return
	}

	// Получаем ID из URL
	idStr := r.URL.Path[len("/Products/delete/"):]
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid Product ID", http.StatusBadRequest)
		return
	}

	// Ищем и удаляем продукт с данным ID
	for i, Product := range products {
		if Product.ID == id {
			// Удаляем продукт из среза
			products = append(products[:i], products[i+1:]...)
			w.WriteHeader(http.StatusNoContent) // Успешное удаление, нет содержимого
			return
		}
	}

	http.Error(w, "Product not found", http.StatusNotFound)
}

// Функция для поиска продукта по ID
func findProductByID(id int) (*Product, bool) {
	for _, product := range products {
		if product.ID == id {
			return &product, true
		}
	}
	return nil, false
}

// обработчик для GET-запроса, возвращает список элементов в корзине
func getBasketHandler(w http.ResponseWriter, r *http.Request) {
	// Устанавливаем заголовки для правильного формата JSON
	w.Header().Set("Content-Type", "application/json")
	// Преобразуем список заметок в JSON
	json.NewEncoder(w).Encode(basket)
}

// Проверка наличия товара в корзине
func checkBasketItemHandler(w http.ResponseWriter, r *http.Request) {
	idStr := r.URL.Path[len("/Basket/"):]
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid product ID", http.StatusBadRequest)
		return
	}

	for _, item := range basket {
		if item.ID == id {
			response := map[string]interface{}{
				"isInBasket": true,
				"itemCount":  item.Counter,
			}
			json.NewEncoder(w).Encode(response)
			return
		}
	}

	response := map[string]interface{}{
		"isInBasket": false,
		"itemCount":  0,
	}
	json.NewEncoder(w).Encode(response)
}

// Обработчик для POST-запроса, добавляет продукт в корзину или обновляет количество
func addToBasketHandler(w http.ResponseWriter, r *http.Request) {
	var req struct {
		GameID int `json:"gameId"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request", http.StatusBadRequest)
		return
	}

	for i, item := range basket {
		if item.ID == req.GameID {
			basket[i].Counter++
			json.NewEncoder(w).Encode(basket[i])
			return
		}
	}

	newItem := Item{ID: req.GameID, Counter: 1}
	basket = append(basket, newItem)
	json.NewEncoder(w).Encode(newItem)
}

// Увеличение количества товара
func increaseBasketItemHandler(w http.ResponseWriter, r *http.Request) {
	var req struct {
		GameID int `json:"gameId"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request", http.StatusBadRequest)
		return
	}

	for i, item := range basket {
		if item.ID == req.GameID {
			basket[i].Counter++
			json.NewEncoder(w).Encode(basket[i])
			return
		}
	}
	http.Error(w, "Item not found in basket", http.StatusNotFound)
}

// Уменьшение количества товара в корзине
func decreaseBasketItemHandler(w http.ResponseWriter, r *http.Request) {
	var req struct {
		GameID int `json:"gameId"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request", http.StatusBadRequest)
		return
	}

	for i, item := range basket {
		if item.ID == req.GameID {
			if basket[i].Counter > 1 {
				basket[i].Counter--
				json.NewEncoder(w).Encode(basket[i])
			}
			return
		}
	}
	http.Error(w, "Item not found in basket", http.StatusNotFound)
}

// Удаление товара из корзины
func removeFromBasketHandler(w http.ResponseWriter, r *http.Request) {
	var req struct {
		GameID int `json:"gameId"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request", http.StatusBadRequest)
		return
	}

	for i, item := range basket {
		if item.ID == req.GameID {
			basket = append(basket[:i], basket[i+1:]...)
			json.NewEncoder(w).Encode(map[string]string{"message": "Item removed from basket"})
			return
		}
	}
	http.Error(w, "Item not found in basket", http.StatusNotFound)
}

// Обработчик для обновления статуса избранного
func updateFavoriteStatus(w http.ResponseWriter, r *http.Request) {

	idStr := r.URL.Path[len("/products/update/"):]
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid item ID", http.StatusBadRequest)
		return
	}
	var req struct {
		IsFavorite bool `json:"isFavorite"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request payload", http.StatusBadRequest)
		return
	}

	for i, product := range products {
		if product.ID == id {
			products[i].IsFavorite = req.IsFavorite

			w.Header().Set("Content-Type", "application/json")
			json.NewEncoder(w).Encode(products[i])
			return
		}
	}

	http.Error(w, "Product not found", http.StatusNotFound)
}

func main() {
	http.HandleFunc("/products", getProductsHandler)           // Получить все продукты
	http.HandleFunc("/products/create", createProductHandler)  // Создать продукт
	http.HandleFunc("/products/", getProductByIDHandler)       // Получить продукт по ID
	http.HandleFunc("/products/delete/", deleteProductHandler) // Удалить продукт
	http.HandleFunc("/products/update/", updateFavoriteStatus) // Обновление статуса избранного

	http.HandleFunc("/basket", getBasketHandler)                   // Получить все элементы корзины
	http.HandleFunc("/basket/", checkBasketItemHandler)            // Проверить есть ли товар в корзине
	http.HandleFunc("/basket/add", addToBasketHandler)             // Добавить продукт в корзину или обновить количество
	http.HandleFunc("/basket/increase", increaseBasketItemHandler) // Увеличить количество товара
	http.HandleFunc("/basket/decrease", decreaseBasketItemHandler) // Уменьшить количество товара
	http.HandleFunc("/basket/remove", removeFromBasketHandler)     // Удалить товар из корзины

	fmt.Println("Server is running on port 8080!")
	http.ListenAndServe(":8080", nil)
}