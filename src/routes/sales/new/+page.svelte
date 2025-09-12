<script lang="ts">
  import { onMount } from 'svelte';
  import { fly, fade } from 'svelte/transition';
  
  // Estados
  let loading = false;
  let searchTerm = '';
  let customerName = '';
  let customerDoc = '';
  let paymentMethod = 'efectivo';
  let saleNotes = '';
  
  // Datos de ejemplo - productos disponibles
  let products = [
    { id: 1, name: 'Paracetamol 500mg', price: 5.99, stock: 100, category: 'Analgésico' },
    { id: 2, name: 'Ibuprofeno 400mg', price: 7.50, stock: 75, category: 'Antiinflamatorio' },
    { id: 3, name: 'Omeprazol 20mg', price: 12.00, stock: 50, category: 'Protector gástrico' },
    { id: 4, name: 'Amoxicilina 500mg', price: 15.75, stock: 30, category: 'Antibiótico' },
    { id: 5, name: 'Loratadina 10mg', price: 8.25, stock: 60, category: 'Antihistamínico' },
  ];
  
  // Carrito de compras
  let cart = [];
  
  // Filtro de productos
  $: filteredProducts = searchTerm === '' 
    ? products 
    : products.filter(p => 
        p.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        p.category.toLowerCase().includes(searchTerm.toLowerCase())
      );
  
  // Cálculos
  $: subtotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
  $: tax = subtotal * 0.18; // 18% de IGV
  $: total = subtotal + tax;
  
  // Agregar producto al carrito
  function addToCart(product) {
    const existingItem = cart.find(item => item.id === product.id);
    
    if (existingItem) {
      if (existingItem.quantity < product.stock) {
        existingItem.quantity += 1;
        cart = [...cart]; // Forzar actualización reactiva
      }
    } else {
      cart = [...cart, { ...product, quantity: 1 }];
    }
  }
  
  // Actualizar cantidad en el carrito
  function updateQuantity(productId, newQuantity) {
    const item = cart.find(item => item.id === productId);
    if (item) {
      if (newQuantity > 0 && newQuantity <= products.find(p => p.id === productId).stock) {
        item.quantity = parseInt(newQuantity) || 1;
        cart = [...cart];
      } else if (newQuantity === 0) {
        removeFromCart(productId);
      }
    }
  }
  
  // Eliminar producto del carrito
  function removeFromCart(productId) {
    cart = cart.filter(item => item.id !== productId);
  }
  
  // Procesar venta
  function processSale() {
    if (cart.length === 0) {
      alert('El carrito está vacío');
      return;
    }
    
    loading = true;
    
    // Simular envío a la API
    setTimeout(() => {
      const saleData = {
        customer: {
          name: customerName,
          document: customerDoc
        },
        items: cart.map(item => ({
          productId: item.id,
          quantity: item.quantity,
          price: item.price
        })),
        subtotal,
        tax,
        total,
        paymentMethod,
        notes: saleNotes,
        date: new Date().toISOString()
      };
      
      console.log('Venta procesada:', saleData);
      
      // Mostrar mensaje de éxito y limpiar
      alert(`Venta completada exitosamente por S/ ${total.toFixed(2)}`);
      resetForm();
      loading = false;
    }, 1000);
  }
  
  // Reiniciar formulario
  function resetForm() {
    cart = [];
    customerName = '';
    customerDoc = '';
    paymentMethod = 'efectivo';
    saleNotes = '';
  }
</script>

<div class="min-h-screen bg-gray-50 py-8">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="lg:grid lg:grid-cols-3 lg:gap-8">
      <!-- Panel de productos -->
      <div class="lg:col-span-2 space-y-6">
        <!-- Encabezado -->
        <div class="bg-white shadow rounded-lg p-6">
          <h1 class="text-2xl font-bold text-gray-900">Nueva Venta</h1>
          <p class="mt-1 text-sm text-gray-500">Busca y selecciona los productos para la venta</p>
          
          <!-- Búsqueda de productos -->
          <div class="mt-4 relative">
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd" />
              </svg>
            </div>
            <input
              type="text"
              bind:value={searchTerm}
              class="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md leading-5 bg-white placeholder-gray-500 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
              placeholder="Buscar productos..."
            />
          </div>
        </div>
        
        <!-- Lista de productos -->
        <div class="bg-white shadow rounded-lg overflow-hidden">
          <div class="divide-y divide-gray-200">
            {#if filteredProducts.length === 0}
              <div class="p-8 text-center">
                <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" />
                </svg>
                <h3 class="mt-2 text-sm font-medium text-gray-900">No se encontraron productos</h3>
                <p class="mt-1 text-sm text-gray-500">Intenta con otro término de búsqueda</p>
              </div>
            {:else}
              <ul class="divide-y divide-gray-200 max-h-[500px] overflow-y-auto">
                {#each filteredProducts as product (product.id)}
                  <li 
                    in:fly={{ y: 20, duration: 300 }}
                    class="p-4 hover:bg-gray-50 transition-colors duration-150 flex justify-between items-center"
                  >
                    <div>
                      <div class="font-medium text-gray-900">{product.name}</div>
                      <div class="text-sm text-gray-500">{product.category}</div>
                      <div class="mt-1">
                        <span class="text-sm font-medium text-indigo-600">S/ {product.price.toFixed(2)}</span>
                        <span class="mx-2 text-gray-300">•</span>
                        <span class="text-xs text-gray-500">{product.stock} en stock</span>
                      </div>
                    </div>
                    <button
                      on:click={() => addToCart(product)}
                      class="ml-4 inline-flex items-center px-3 py-1.5 border border-transparent text-xs font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                    >
                      Agregar
                    </button>
                  </li>
                {/each}
              </ul>
            {/if}
          </div>
        </div>
      </div>
      
      <!-- Panel del carrito -->
      <div class="mt-8 lg:mt-0">
        <div class="bg-white shadow rounded-lg sticky top-8">
          <div class="p-6">
            <h2 class="text-lg font-medium text-gray-900">Resumen de Venta</h2>
            
            <!-- Información del cliente -->
            <div class="mt-6 space-y-4">
              <div>
                <label for="customer-name" class="block text-sm font-medium text-gray-700">Cliente</label>
                <input
                  type="text"
                  id="customer-name"
                  bind:value={customerName}
                  class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                  placeholder="Nombre del cliente"
                />
              </div>
              <div>
                <label for="customer-doc" class="block text-sm font-medium text-gray-700">DNI/RUC</label>
                <input
                  type="text"
                  id="customer-doc"
                  bind:value={customerDoc}
                  class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                  placeholder="N° de documento"
                />
              </div>
              <div>
                <label for="payment-method" class="block text-sm font-medium text-gray-700">Método de pago</label>
                <select
                  id="payment-method"
                  bind:value={paymentMethod}
                  class="mt-1 block w-full border border-gray-300 bg-white rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                >
                  <option value="efectivo">Efectivo</option>
                  <option value="tarjeta">Tarjeta de crédito/débito</option>
                  <option value="transferencia">Transferencia bancaria</option>
                  <option value="yape">Yape/Plin</option>
                </select>
              </div>
              <div>
                <label for="sale-notes" class="block text-sm font-medium text-gray-700">Notas</label>
                <textarea
                  id="sale-notes"
                  bind:value={saleNotes}
                  rows="2"
                  class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                  placeholder="Notas adicionales..."
                ></textarea>
              </div>
            </div>
            
            <!-- Lista de productos en el carrito -->
            <div class="mt-6">
              <h3 class="text-sm font-medium text-gray-900">Productos ({cart.length})</h3>
              
              {#if cart.length === 0}
                <p class="mt-2 text-sm text-gray-500">No hay productos en el carrito</p>
              {:else}
                <ul class="mt-4 space-y-3">
                  {#each cart as item (item.id)}
                    <li 
                      in:fade
                      class="flex justify-between items-start py-2 border-b border-gray-100"
                    >
                      <div class="flex-1">
                        <div class="font-medium text-gray-900">{item.name}</div>
                        <div class="flex items-center mt-1">
                          <button
                            on:click={() => updateQuantity(item.id, item.quantity - 1)}
                            class="text-gray-400 hover:text-gray-600"
                          >
                            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4" />
                            </svg>
                          </button>
                          <input
                            type="number"
                            min="1"
                            max={item.stock}
                            bind:value={item.quantity}
                            on:change={(e) => updateQuantity(item.id, parseInt(e.target.value))}
                            class="mx-2 w-12 text-center border-gray-300 rounded-md text-sm"
                          />
                          <button
                            on:click={() => updateQuantity(item.id, item.quantity + 1)}
                            class="text-gray-400 hover:text-gray-600"
                            disabled={item.quantity >= item.stock}
                          >
                            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                            </svg>
                          </button>
                          <span class="text-sm text-gray-500 ml-2">x S/ {item.price.toFixed(2)}</span>
                        </div>
                      </div>
                      <div class="flex items-center">
                        <span class="font-medium text-gray-900">S/ {(item.price * item.quantity).toFixed(2)}</span>
                        <button
                          on:click={() => removeFromCart(item.id)}
                          class="ml-2 text-red-600 hover:text-red-800"
                        >
                          <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                          </svg>
                        </button>
                      </div>
                    </li>
                  {/each}
                </ul>
                
                <!-- Resumen de totales -->
                <div class="mt-6 space-y-3 border-t border-gray-200 pt-4">
                  <div class="flex justify-between text-sm">
                    <span class="text-gray-600">Subtotal</span>
                    <span class="font-medium">S/ {subtotal.toFixed(2)}</span>
                  </div>
                  <div class="flex justify-between text-sm">
                    <span class="text-gray-600">IGV (18%)</span>
                    <span class="font-medium">S/ {tax.toFixed(2)}</span>
                  </div>
                  <div class="flex justify-between text-lg font-bold border-t border-gray-200 pt-2">
                    <span>Total</span>
                    <span>S/ {total.toFixed(2)}</span>
                  </div>
                </div>
                
                <!-- Botones de acción -->
                <div class="mt-6 space-y-3">
                  <button
                    on:click={processSale}
                    disabled={loading || cart.length === 0}
                    class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    {#if loading}
                      <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                      </svg>
                      Procesando...
                    {:else}
                      <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd" />
                      </svg>
                      Procesar Venta
                    {/if}
                  </button>
                  {#if cart.length > 0}
                    <button
                      on:click={resetForm}
                      type="button"
                      class="w-full flex justify-center py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                    >
                      Cancelar Venta
                    </button>
                  {/if}
                </div>
              {/if}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<style>
  /* Ocultar flechas en inputs de tipo number */
  input[type=number]::-webkit-outer-spin-button,
  input[type=number]::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
  }
  
  input[type=number] {
    -moz-appearance: textfield;
  }
  
  /* Estilo para la barra de desplazamiento */
  ::-webkit-scrollbar {
    width: 6px;
    height: 6px;
  }
  
  ::-webkit-scrollbar-track {
    background: #f1f1f1;
    border-radius: 10px;
  }
  
  ::-webkit-scrollbar-thumb {
    background: #c7d2fe;
    border-radius: 10px;
  }
  
  ::-webkit-scrollbar-thumb:hover {
    background: #a5b4fc;
  }
</style>
