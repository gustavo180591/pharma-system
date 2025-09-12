<script lang="ts">
  import { onMount } from 'svelte';
  import { fade, fly } from 'svelte/transition';
  
  // Estados
  let loading = true;
  let searchTerm = '';
  let selectedCategory = 'all';
  
  // Datos de ejemplo - en una aplicación real, esto vendría de una API
  let products = [];
  
  // Simular carga de datos
  onMount(async () => {
    // Simular retardo de red
    await new Promise(resolve => setTimeout(resolve, 800));
    
    products = [
      { 
        id: 1, 
        name: 'Paracetamol 500mg', 
        price: 5.99, 
        stock: 100, 
        category: 'Analgésico',
        image: 'https://via.placeholder.com/80/93c5fd/ffffff?text=P'
      },
      { 
        id: 2, 
        name: 'Ibuprofeno 400mg', 
        price: 7.50, 
        stock: 75, 
        category: 'Antiinflamatorio',
        image: 'https://via.placeholder.com/80/93c5fd/ffffff?text=I'
      },
      { 
        id: 3, 
        name: 'Omeprazol 20mg', 
        price: 12.00, 
        stock: 50, 
        category: 'Protector gástrico',
        image: 'https://via.placeholder.com/80/93c5fd/ffffff?text=O'
      },
      { 
        id: 4, 
        name: 'Amoxicilina 500mg', 
        price: 15.75, 
        stock: 30, 
        category: 'Antibiótico',
        image: 'https://via.placeholder.com/80/93c5fd/ffffff?text=A'
      },
      { 
        id: 5, 
        name: 'Loratadina 10mg', 
        price: 8.25, 
        stock: 60, 
        category: 'Antihistamínico',
        image: 'https://via.placeholder.com/80/93c5fd/ffffff?text=L'
      },
    ];
    
    loading = false;
  });
  
  // Filtrar productos
  $: filteredProducts = products.filter(product => {
    const matchesSearch = product.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         product.category.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesCategory = selectedCategory === 'all' || product.category === selectedCategory;
    return matchesSearch && matchesCategory;
  });
  
  // Obtener categorías únicas
  $: categories = ['all', ...new Set(products.map(p => p.category))];
</script>

<div class="min-h-screen bg-gray-50">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Header con búsqueda y acciones -->
    <div class="md:flex md:items-center md:justify-between mb-8">
      <div class="flex-1 min-w-0">
        <h1 class="text-3xl font-bold text-gray-900">Catálogo de Productos</h1>
        <p class="mt-1 text-sm text-gray-500">Gestiona los productos de tu farmacia de manera eficiente</p>
      </div>
      <div class="mt-4 flex md:mt-0 md:ml-4">
        <a 
          href="/products/nuevo" 
          class="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
        >
          <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M10 5a1 1 0 011 1v3h3a1 1 0 110 2h-3v3a1 1 0 11-2 0v-3H6a1 1 0 110-2h3V6a1 1 0 011-1z" clip-rule="evenodd" />
          </svg>
          Nuevo Producto
        </a>
      </div>
    </div>

    <!-- Filtros -->
    <div class="bg-white shadow rounded-lg p-4 mb-6">
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div class="md:col-span-2">
          <label for="search" class="sr-only">Buscar</label>
          <div class="relative rounded-md shadow-sm">
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd" />
              </svg>
            </div>
            <input 
              type="text" 
              id="search"
              bind:value={searchTerm}
              class="focus:ring-indigo-500 focus:border-indigo-500 block w-full pl-10 pr-12 sm:text-sm border-gray-300 rounded-md h-10"
              placeholder="Buscar productos..."
            >
          </div>
        </div>
        <div>
          <label for="category" class="sr-only">Categoría</label>
          <select 
            id="category"
            bind:value={selectedCategory}
            class="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md h-10"
          >
            {#each categories as category}
              <option value={category}>
                {category === 'all' ? 'Todas las categorías' : category}
              </option>
            {/each}
          </select>
        </div>
      </div>
    </div>

    <!-- Tarjeta de productos -->
    <div class="bg-white shadow overflow-hidden sm:rounded-lg">
      {#if loading}
        <!-- Estado de carga -->
        <div class="p-8 text-center">
          <div class="animate-pulse flex flex-col items-center">
            <div class="h-4 bg-gray-200 rounded w-1/4 mb-4"></div>
            <div class="space-y-4 w-full">
              {#each Array(5).fill(0) as _, i (i)}
                <div class="h-12 bg-gray-100 rounded w-full"></div>
              {/each}
            </div>
          </div>
        </div>
      {:else if filteredProducts.length === 0}
        <!-- Estado vacío -->
        <div class="text-center py-12 px-4">
          <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" />
          </svg>
          <h3 class="mt-2 text-sm font-medium text-gray-900">No se encontraron productos</h3>
          <p class="mt-1 text-sm text-gray-500">Intenta ajustar tu búsqueda o filtro para encontrar lo que buscas.</p>
          <div class="mt-6">
            <button 
              on:click={() => {
                searchTerm = '';
                selectedCategory = 'all';
              }}
              class="inline-flex items-center px-4 py-2 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            >
              <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M4 2a1 1 0 011 1v2.101a7.002 7.002 0 0111.601 2.566 1 1 0 11-1.885.666A5.002 5.002 0 005.999 7H9a1 1 0 010 2H4a1 1 0 01-1-1V3a1 1 0 011-1zm.008 9.057a1 1 0 011.276.61A5.002 5.002 0 0014.001 13H11a1 1 0 110-2h5a1 1 0 011 1v5a1 1 0 11-2 0v-2.101a7.002 7.002 0 01-11.601-2.566 1 1 0 01.61-1.276z" clip-rule="evenodd" />
              </svg>
              Restablecer filtros
            </button>
          </div>
        </div>
      {:else}
        <!-- Lista de productos -->
        <div class="overflow-hidden">
          <div class="hidden md:block">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-50">
                <tr>
                  <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Producto</th>
                  <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Categoría</th>
                  <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Precio</th>
                  <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Stock</th>
                  <th scope="col" class="relative px-6 py-3">
                    <span class="sr-only">Acciones</span>
                  </th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                {#each filteredProducts as product (product.id)}
                  <tr 
                    in:fly={{ y: 20, duration: 300, delay: 100 }}
                    class="hover:bg-gray-50 transition-colors duration-150"
                  >
                    <td class="px-6 py-4 whitespace-nowrap">
                      <div class="flex items-center">
                        <div class="flex-shrink-0 h-10 w-10 rounded-full overflow-hidden bg-indigo-100 flex items-center justify-center">
                          {#if product.image}
                            <img class="h-10 w-10 object-cover" src={product.image} alt={product.name}>
                          {:else}
                            <span class="text-indigo-600 font-medium">{product.name.charAt(0)}</span>
                          {/if}
                        </div>
                        <div class="ml-4">
                          <div class="text-sm font-medium text-gray-900">{product.name}</div>
                          <div class="text-sm text-gray-500">ID: {product.id}</div>
                        </div>
                      </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-indigo-100 text-indigo-800">
                        {product.category}
                      </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 font-medium">
                      ${product.price.toFixed(2)}
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <div class="flex items-center">
                        <div class="w-24 mr-2">
                          <div class="w-full bg-gray-200 rounded-full h-2">
                            <div 
                              class="h-2 rounded-full {product.stock > 20 ? 'bg-green-500' : 'bg-red-500'}" 
                              style="width: {Math.min(100, (product.stock / 100) * 100)}%"
                            ></div>
                          </div>
                        </div>
                        <span class={`text-sm font-medium ${product.stock > 20 ? 'text-green-600' : 'text-red-600'}`}>
                          {product.stock}
                        </span>
                      </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                      <div class="flex justify-end space-x-2">
                        <a 
                          href="/products/{product.id}" 
                          class="text-indigo-600 hover:text-indigo-900"
                          title="Ver detalles"
                        >
                          <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                          </svg>
                        </a>
                        <a 
                          href="#" 
                          class="text-yellow-600 hover:text-yellow-900"
                          title="Editar"
                        >
                          <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                          </svg>
                        </a>
                        <button 
                          class="text-red-600 hover:text-red-900"
                          title="Eliminar"
                        >
                          <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                          </svg>
                        </button>
                      </div>
                    </td>
                  </tr>
                {/each}
              </tbody>
            </table>
          </div>
          
          <!-- Vista móvil -->
          <div class="md:hidden">
            <div class="divide-y divide-gray-200">
              {#each filteredProducts as product (product.id)}
                <div 
                  in:fly={{ y: 20, duration: 300, delay: 100 }}
                  class="p-4 hover:bg-gray-50 transition-colors duration-150"
                >
                  <div class="flex items-center justify-between">
                    <div class="flex items-center">
                      <div class="flex-shrink-0 h-12 w-12 rounded-full overflow-hidden bg-indigo-100 flex items-center justify-center">
                        {#if product.image}
                          <img class="h-12 w-12 object-cover" src={product.image} alt={product.name}>
                        {:else}
                          <span class="text-indigo-600 font-medium text-lg">{product.name.charAt(0)}</span>
                        {/if}
                      </div>
                      <div class="ml-4">
                        <div class="text-sm font-medium text-gray-900">{product.name}</div>
                        <div class="text-sm text-gray-500">{product.category}</div>
                      </div>
                    </div>
                    <div class="text-right">
                      <div class="text-sm font-medium text-gray-900">${product.price.toFixed(2)}</div>
                      <div class={`text-xs ${product.stock > 20 ? 'text-green-600' : 'text-red-600'}`}>
                        {product.stock} en stock
                      </div>
                    </div>
                  </div>
                  <div class="mt-2 flex justify-end space-x-2">
                    <a 
                      href="/products/{product.id}" 
                      class="text-indigo-600 hover:text-indigo-900 text-sm font-medium"
                    >
                      Ver
                    </a>
                    <a 
                      href="#" 
                      class="text-yellow-600 hover:text-yellow-900 text-sm font-medium"
                    >
                      Editar
                    </a>
                    <button 
                      class="text-red-600 hover:text-red-900 text-sm font-medium"
                    >
                      Eliminar
                    </button>
                  </div>
                </div>
              {/each}
            </div>
          </div>
        </div>
      {/if}
    </div>
    
    <!-- Paginación -->
    {#if !loading && filteredProducts.length > 0}
      <div class="bg-white px-4 py-3 flex items-center justify-between border-t border-gray-200 sm:px-6">
        <div class="flex-1 flex justify-between sm:hidden">
          <a href="#" class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
            Anterior
          </a>
          <a href="#" class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
            Siguiente
          </a>
        </div>
        <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
          <div>
            <p class="text-sm text-gray-700">
              Mostrando <span class="font-medium">1</span> a <span class="font-medium">{filteredProducts.length}</span> de{' '}
              <span class="font-medium">{filteredProducts.length}</span> resultados
            </p>
          </div>
          <div>
            <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
              <a href="#" class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                <span class="sr-only">Anterior</span>
                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                  <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" />
                </svg>
              </a>
              <a href="#" aria-current="page" class="z-10 bg-indigo-50 border-indigo-500 text-indigo-600 relative inline-flex items-center px-4 py-2 border text-sm font-medium">
                1
              </a>
              <a href="#" class="bg-white border-gray-300 text-gray-500 hover:bg-gray-50 relative inline-flex items-center px-4 py-2 border text-sm font-medium">
                2
              </a>
              <a href="#" class="bg-white border-gray-300 text-gray-500 hover:bg-gray-50 relative inline-flex items-center px-4 py-2 border text-sm font-medium">
                3
              </a>
              <a href="#" class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                <span class="sr-only">Siguiente</span>
                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                  <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
                </svg>
              </a>
            </nav>
          </div>
        </div>
      </div>
    {/if}
  </div>
</div>
