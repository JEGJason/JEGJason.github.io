<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Compras</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }
        .container {
            max-width: 1200px;
            margin: auto;
            padding: 20px;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        input[type="text"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .categories {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
        }
        .category {
            padding: 10px;
            cursor: pointer;
            background-color: #fff;
            border: 1px solid #ccc;
            border-radius: 5px;
            text-align: center;
            flex: 1;
            margin: 0 5px;
        }
        .category:hover {
            background-color: #dff0d8;
        }
        .items {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 10px;
        }
        .item {
            padding: 10px;
            border: 1px solid #ccc;
            background-color: #fff;
            text-align: center;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .item:hover {
            background-color: #d9edf7;
        }
        .shopping-list {
            margin-top: 20px;
            padding: 10px;
            border: 1px solid #ccc;
            background-color: #fff;
            border-radius: 5px;
        }
        .shopping-list li {
            padding: 5px 10px;
            margin: 5px 0;
            background-color: #f2f2f2;
            border-radius: 3px;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .shopping-list li:hover {
            background-color: #f8d7da;
        }
        .quantity {
            margin-left: 10px;
            font-size: 0.9em;
            color: #666;
        }
        .save-button {
            display: block;
            margin: 20px auto;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1em;
            text-align: center;
        }
        .save-button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Lista San Eduardo</h1>
        <input type="text" id="search" placeholder="Buscar artículos...">
        <div class="categories">
            <div class="category" data-category="all">Todos</div>
            <div class="category" data-category="vegetables">Verduras</div>
            <div class="category" data-category="cleaning">Limpieza</div>
            <div class="category" data-category="other">Otros</div>
        </div>
        <div class="items" id="itemContainer"></div>
        <ul class="shopping-list" id="shoppingList"></ul>
        <button class="save-button" id="saveButton">Guardar Lista como Imagen</button>
    </div>
    <script>
        const items = [
            // Vegetables
            "Tomate", "Cebolla", "Ajo", "Pimiento", "Chiles Jalapeños", 
            "Frijoles", "Plátanos", "Elote", "Yuca", "Cilantro", 
            "Zanahoria", "Papa", "Calabacín", "Lechuga", "Espinaca", 
            "Pepino", "Rábanos", "Repollo", "Camote", "Hierbabuena",

            // Cleaning
            "Cloro", "Jabón", "Guantes", "Toallas de Papel", "Esponja", 
            "Detergente", "Limpiador Multiusos", "Trapeador", "Cubeta", "Suavizante de Telas", 
            "Cepillo de Fregar", "Bolsas de Basura", "Desinfectante", "Escoba", "Recogedor", 

            // Other Foods
            "Arroz", "Maseca", "Harina", "Aceite Vegetal", "Azúcar", 
            "Sal", "Pimienta", "Canela", "Vainilla", "Vinagre", 
            "Queso", "Crema", "Tortillas", "Pan Dulce", "Leche", 
            "Huevos", "Pasta", "Salsa de Tomate", "Maíz", "Chiles Secos", 
            "Achiote", "Comino", "Orégano", "Albahaca", "Laurel"
        ];

        const itemContainer = document.getElementById("itemContainer");
        const shoppingList = document.getElementById("shoppingList");
        const search = document.getElementById("search");
        const categories = document.querySelectorAll(".category");

        function renderItems(filteredItems = items) {
            itemContainer.innerHTML = "";
            filteredItems.forEach(item => {
                const div = document.createElement("div");
                div.classList.add("item");
                div.textContent = item;
                div.addEventListener("click", () => addItem(item));
                itemContainer.appendChild(div);
            });
        }

        function addItem(item) {
            const existing = [...shoppingList.children].find(li => li.textContent.includes(item));
            if (existing) {
                const quantity = existing.querySelector(".quantity");
                quantity.textContent = `x${+quantity.textContent.slice(1) + 1}`;
            } else {
                const li = document.createElement("li");
                li.textContent = item;
                const span = document.createElement("span");
                span.className = "quantity";
                span.textContent = "x1";
                li.appendChild(span);
                li.addEventListener("click", () => li.remove());
                shoppingList.appendChild(li);
            }
        }

        document.getElementById("saveButton").addEventListener("click", () => {
            html2canvas(document.querySelector(".shopping-list")).then(canvas => {
                const link = document.createElement("a");
                link.download = "shopping-list.png";
                link.href = canvas.toDataURL();
                link.click();
            });
        });

        search.addEventListener("input", () => {
            const query = search.value.toLowerCase();
            const filteredItems = items.filter(item => item.toLowerCase().includes(query));
            renderItems(filteredItems);
        });

        categories.forEach(category => {
            category.addEventListener("click", () => {
                const categoryFilter = category.dataset.category;
                if (categoryFilter === "all") {
                    renderItems(items);
                } else if (categoryFilter === "vegetables") {
                    renderItems(items.slice(0, 20));
                } else if (categoryFilter === "cleaning") {
                    renderItems(items.slice(20, 35));
                } else {
                    renderItems(items.slice(35));
                }
            });
        });

        renderItems();
    </script>
    <script src="https://cdn.jsdelivr.net/npm/html2canvas"></script>
</body>
</html>