<script lang="ts">
  import { onMount } from 'svelte';
  
  // Datos de ejemplo para productos
  const products = [
    { id: 1, name: 'Paracetamol 500mg', price: 5.99, stock: 100 },
    { id: 2, name: 'Ibuprofeno 400mg', price: 7.50, stock: 75 },
    { id: 3, name: 'Omeprazol 20mg', price: 12.00, stock: 50 },
  ];

  // Carrito de compras
  let cart = [];
  let selectedProduct = '';
  let quantity = 1;
  let searchTerm = '';

  // Calcular total
  $: total = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);

  // Filtrar productos por búsqueda
  $: filteredProducts = products.filter(product => 
    product.name.toLowerCase().includes(searchTerm.toLowerCase())
  );

  // Agregar producto al carrito
  function addToCart() {
    if (!selectedProduct) return;
    
    const product = products.find(p => p.id === parseInt(selectedProduct));
    if (!product) return;

    const existingItem = cart.find(item => item.id === product.id);
    
    if (existingItem) {
      if (existingItem.quantity + quantity > product.stock) {
        alert('No hay suficiente stock disponible');
        return;
      }
      existingItem.quantity += quantity;
    } else {
      if (quantity > product.stock) {
        alert('No hay suficiente stock disponible');
        return;
      }
      cart = [...cart, { ...product, quantity }];
    }
    
    // Resetear el formulario
    selectedProduct = '';
    quantity = 1;
  }

  // Eliminar producto del carrito
  function removeFromCart(productId) {
    cart = cart.filter(item => item.id !== productId);
  }

  // Actualizar cantidad en el carrito
  function updateQuantity(productId, newQuantity) {
    if (newQuantity < 1) return;
    
    const product = products.find(p => p.id === productId);
    if (newQuantity > product.stock) {
      alert('No hay suficiente stock disponible');
      return;
    }
    
    cart = cart.map(item => 
      item.id === productId ? { ...item, quantity: newQuantity } : item
    );
  }

  // Finalizar venta
  function completeSale() {
    if (cart.length === 0) {
      alert('El carrito está vacío');
      return;
    }
    
    // Aquí iría la lógica para guardar la venta en la base de datos
    alert(`Venta completada por $${total.toFixed(2)}`);
    
    // Limpiar carrito
    cart = [];
  }
</script>

<div class="container mx-auto px-4 py-8">
  <h1 class="text-3xl font-bold mb-8 text-gray-800">Punto de Venta</h1>
  
  <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
    <!-- Panel de productos -->
    <div class="lg:col-span-2 bg-white p-6 rounded-lg shadow-md">
      <h2 class="text-xl font-semibold mb-4">Productos</h2>
      
      <!-- Búsqueda -->
      <div class="mb-4">
        <input 
          type="text" 
          placeholder="Buscar producto..." 
          class="w-full p-2 border rounded-md"
          bind:value={searchTerm}
        >
      </div>
      
      <!-- Lista de productos -->
      <div class="space-y-2 mb-6">
        {#each filteredProducts as product}
          <div class="flex justify-between items-center p-3 border rounded hover:bg-gray-50">
            <div>
              <div class="font-medium">{product.name}</div>
              <div class="text-sm text-gray-600">${product.price.toFixed(2)} c/u</div>
              <div class="text-xs text-gray-500">Stock: {product.stock}</div>
            </div>
            <button 
              on:click={() => {
                selectedProduct = product.id;
                addToCart();
              }}
              class="bg-indigo-600 text-white px-3 py-1 rounded text-sm hover:bg-indigo-700"
            >
              Agregar
            </button>
          </div>
        {/each}
      </div>
      
      <!-- Formulario para agregar producto -->
      <div class="border-t pt-4">
        <h3 class="font-medium mb-3">Agregar producto manualmente</h3>
        <div class="flex space-x-2">
          <select 
            class="flex-1 p-2 border rounded"
            bind:value={selectedProduct}
          >
            <option value="">Seleccionar producto</option>
            {#each products as product}
              <option value={product.id}>
                {product.name} (${product.price.toFixed(2)})
              </option>
            {/each}
          </select>
          <input 
            type="number" 
            min="1" 
            bind:value={quantity}
            class="w-20 p-2 border rounded"
          >
          <button 
            on:click={addToCart}
            class="bg-indigo-600 text-white px-4 py-2 rounded hover:bg-indigo-700"
          >
            Agregar
          </button>
        </div>
      </div>
    </div>
    
    <!-- Panel del carrito -->
    <div class="bg-white p-6 rounded-lg shadow-md h-fit">
      <h2 class="text-xl font-semibold mb-4">Carrito de Venta</h2>
      
      {#if cart.length === 0}
        <p class="text-gray-500 text-center py-8">El carrito está vacío</p>
      {:else}
        <div class="space-y-4 mb-6">
          {#each cart as item}
            <div class="border-b pb-3">
              <div class="flex justify-between items-start">
                <div>
                  <div class="font-medium">{item.name}</div>
                  <div class="text-sm text-gray-600">${item.price.toFixed(2)} c/u</div>
                </div>
                <button 
                  on:click={() => removeFromCart(item.id)}
                  class="text-red-500 hover:text-red-700"
                >
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                  </svg>
                </button>
              </div>
              <div class="flex items-center mt-1">
                <button 
                  on:click={() => updateQuantity(item.id, item.quantity - 1)}
                  class="w-6 h-6 flex items-center justify-center border rounded"
                >
                  -
                </button>
                <span class="mx-2 w-8 text-center">{item.quantity}</span>
                <button 
                  on:click={() => updateQuantity(item.id, item.quantity + 1)}
                  class="w-6 h-6 flex items-center justify-center border rounded"
                >
                  +
                </button>
                <div class="ml-auto font-medium">
                  ${(item.price * item.quantity).toFixed(2)}
                </div>
              </div>
            </div>
          {/each}
        </div>
        
        <div class="border-t pt-4">
          <div class="flex justify-between text-lg font-bold mb-4">
            <span>Total:</span>
            <span>${total.toFixed(2)}</span>
          </div>
          
          <button 
            on:click={completeSale}
            class="w-full bg-green-600 text-white py-3 rounded-lg font-medium hover:bg-green-700 transition-colors"
          >
            Finalizar Venta
          </button>
        </div>
      {/if}
    </div>
  </div>
</div>
