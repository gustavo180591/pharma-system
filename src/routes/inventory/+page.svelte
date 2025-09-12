<script lang="ts">
  import { onMount } from 'svelte';
  
  // Datos de ejemplo - en una aplicación real, esto vendría de una API
  let inventory = [
    { id: 1, name: 'Paracetamol 500mg', category: 'Analgésico', stock: 100, minStock: 20, price: 5.99, lastUpdated: '2025-09-10' },
    { id: 2, name: 'Ibuprofeno 400mg', category: 'Antiinflamatorio', stock: 75, minStock: 15, price: 7.50, lastUpdated: '2025-09-09' },
    { id: 3, name: 'Omeprazol 20mg', category: 'Protector gástrico', stock: 50, minStock: 10, price: 12.00, lastUpdated: '2025-09-11' },
    { id: 4, name: 'Amoxicilina 500mg', category: 'Antibiótico', stock: 30, minStock: 5, price: 15.75, lastUpdated: '2025-09-08' },
    { id: 5, name: 'Loratadina 10mg', category: 'Antihistamínico', stock: 60, minStock: 10, price: 8.25, lastUpdated: '2025-09-11' },
  ];

  // Filtros
  let searchTerm = '';
  let selectedCategory = 'all';
  let lowStockOnly = false;
  
  // Estado del modal
  let showAddModal = false;
  let newProduct = {
    name: '',
    category: '',
    stock: 0,
    minStock: 0,
    price: 0
  };

  // Categorías únicas para el filtro
  $: categories = ['all', ...new Set(inventory.map(item => item.category))];
  
  // Filtrar inventario
  $: filteredInventory = inventory.filter(item => {
    const matchesSearch = item.name.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesCategory = selectedCategory === 'all' || item.category === selectedCategory;
    const matchesLowStock = !lowStockOnly || item.stock <= item.minStock;
    
    return matchesSearch && matchesCategory && matchesLowStock;
  });

  // Agregar nuevo producto
  function addProduct() {
    if (!newProduct.name || !newProduct.category) return;
    
    const product = {
      id: Math.max(0, ...inventory.map(p => p.id)) + 1,
      ...newProduct,
      lastUpdated: new Date().toISOString().split('T')[0]
    };
    
    inventory = [...inventory, product];
    closeModal();
  }
  
  // Actualizar stock
  function updateStock(id, newStock) {
    if (isNaN(newStock) || newStock < 0) return;
    
    inventory = inventory.map(item => 
      item.id === id 
        ? { ...item, stock: parseInt(newStock), lastUpdated: new Date().toISOString().split('T')[0] } 
        : item
    );
  }
  
  // Eliminar producto
  function deleteProduct(id) {
    if (confirm('¿Estás seguro de que deseas eliminar este producto?')) {
      inventory = inventory.filter(item => item.id !== id);
    }
  }
  
  // Cerrar modal y limpiar formulario
  function closeModal() {
    showAddModal = false;
    newProduct = {
      name: '',
      category: '',
      stock: 0,
      minStock: 0,
      price: 0
    };
  }
</script>

<div class="container mx-auto px-4 py-8">
  <div class="flex justify-between items-center mb-8">
    <h1 class="text-3xl font-bold text-gray-800">Gestión de Inventario</h1>
    <button 
      on:click={() => showAddModal = true}
      class="bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700 transition-colors"
    >
      + Agregar Producto
    </button>
  </div>
  
  <!-- Filtros -->
  <div class="bg-white p-4 rounded-lg shadow-md mb-6">
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
      <div class="md:col-span-2">
        <label for="search" class="block text-sm font-medium text-gray-700 mb-1">Buscar</label>
        <input 
          type="text" 
          id="search"
          bind:value={searchTerm}
          placeholder="Buscar producto..." 
          class="w-full p-2 border rounded-md"
        >
      </div>
      
      <div>
        <label for="category" class="block text-sm font-medium text-gray-700 mb-1">Categoría</label>
        <select 
          id="category"
          bind:value={selectedCategory}
          class="w-full p-2 border rounded-md"
        >
          {#each categories as category}
            <option value={category}>
              {category === 'all' ? 'Todas las categorías' : category}
            </option>
          {/each}
        </select>
      </div>
      
      <div class="flex items-end">
        <label class="flex items-center space-x-2">
          <input 
            type="checkbox" 
            bind:checked={lowStockOnly}
            class="rounded border-gray-300 text-indigo-600 focus:ring-indigo-500"
          >
          <span class="text-sm font-medium text-gray-700">Mostrar solo stock bajo</span>
        </label>
      </div>
    </div>
  </div>
  
  <!-- Tabla de inventario -->
  <div class="bg-white shadow-md rounded-lg overflow-hidden">
    <div class="overflow-x-auto">
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
          <tr>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Producto</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Categoría</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Stock</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Mínimo</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Precio</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Última actualización</th>
            <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Acciones</th>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
          {#if filteredInventory.length === 0}
            <tr>
              <td colspan="7" class="px-6 py-4 text-center text-gray-500">
                No se encontraron productos que coincidan con los filtros
              </td>
            </tr>
          {:else}
            {#each filteredInventory as item}
              <tr class={item.stock <= item.minStock ? 'bg-red-50' : 'hover:bg-gray-50'}>
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="text-sm font-medium text-gray-900">{item.name}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                    {item.category}
                  </span>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <input 
                    type="number" 
                    min="0"
                    bind:value={item.stock}
                    on:change={() => updateStock(item.id, item.stock)}
                    class={`w-20 p-1 border rounded ${item.stock <= item.minStock ? 'border-red-300 bg-red-50' : ''}`}
                  >
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  {item.minStock}
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  ${item.price.toFixed(2)}
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  {item.lastUpdated}
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                  <button 
                    on:click={() => deleteProduct(item.id)}
                    class="text-red-600 hover:text-red-900 mr-4"
                    title="Eliminar"
                  >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                  </button>
                </td>
              </tr>
            {/each}
          {/if}
        </tbody>
      </table>
    </div>
  </div>
  
  <!-- Resumen -->
  <div class="mt-4 text-sm text-gray-600">
    Mostrando {filteredInventory.length} de {inventory.length} productos
    {lowStockOnly ? ' con stock bajo' : ''}
  </div>
</div>

<!-- Modal para agregar producto -->
{#if showAddModal}
  <div class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-md">
      <div class="px-6 py-4 border-b">
        <h2 class="text-xl font-semibold text-gray-800">Agregar Producto</h2>
      </div>
      
      <div class="p-6 space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Nombre del Producto</label>
          <input 
            type="text" 
            bind:value={newProduct.name}
            class="w-full p-2 border rounded-md"
            placeholder="Ej: Paracetamol 500mg"
          >
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Categoría</label>
          <input 
            type="text" 
            bind:value={newProduct.category}
            class="w-full p-2 border rounded-md"
            placeholder="Ej: Analgésico"
          >
        </div>
        
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Stock Inicial</label>
            <input 
              type="number" 
              min="0"
              bind:value={newProduct.stock}
              class="w-full p-2 border rounded-md"
            >
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Stock Mínimo</label>
            <input 
              type="number" 
              min="0"
              bind:value={newProduct.minStock}
              class="w-full p-2 border rounded-md"
            >
          </div>
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Precio</label>
          <div class="relative">
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <span class="text-gray-500 sm:text-sm">$</span>
            </div>
            <input 
              type="number" 
              min="0"
              step="0.01"
              bind:value={newProduct.price}
              class="pl-7 w-full p-2 border rounded-md"
              placeholder="0.00"
            >
          </div>
        </div>
      </div>
      
      <div class="px-6 py-4 bg-gray-50 flex justify-end space-x-3">
        <button 
          on:click={closeModal}
          class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50"
        >
          Cancelar
        </button>
        <button 
          on:click={addProduct}
          class="px-4 py-2 text-sm font-medium text-white bg-indigo-600 border border-transparent rounded-md hover:bg-indigo-700"
        >
          Guardar Producto
        </button>
      </div>
    </div>
  </div>
{/if}

<style>
  /* Estilos para el input de tipo number sin flechas */
  input[type=number]::-webkit-outer-spin-button,
  input[type=number]::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
  }
  
  input[type=number] {
    -moz-appearance: textfield;
  }
</style>
