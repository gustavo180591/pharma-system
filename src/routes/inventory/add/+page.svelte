<script lang="ts">
  import { onMount } from 'svelte';
  import { fade, fly } from 'svelte/transition';
  
  // Estados del formulario
  let loading = false;
  let success = false;
  
  // Datos del producto
  let product = {
    name: '',
    description: '',
    category: '',
    price: '',
    cost: '',
    stock: '0',
    minStock: '5',
    barcode: '',
    supplier: '',
    location: '',
    requiresPrescription: false,
    expirationDate: ''
  };
  
  // Categorías disponibles
  const categories = [
    'Analgésico',
    'Antiinflamatorio',
    'Antibiótico',
    'Antihistamínico',
    'Antipirético',
    'Antiséptico',
    'Protector gástrico',
    'Suplemento vitamínico',
    'Cuidado personal',
    'Primeros auxilios',
    'Otros'
  ];
  
  // Proveedores (en una aplicación real, esto vendría de una API)
  const suppliers = [
    'Bayer',
    'Pfizer',
    'GSK',
    'Novartis',
    'Sanofi',
    'Genfar',
    'Bagó',
    'AC Farma',
    'Otro'
  ];
  
  // Ubicaciones en el almacén
  const locations = [
    'Estante A1',
    'Estante A2',
    'Estante B1',
    'Estante B2',
    'Refrigerador',
    'Gabinete de control',
    'Área de cuarentena',
    'Otro'
  ];
  
  // Validación de campos requeridos
  $: formIsValid = (
    product.name.trim() !== '' &&
    product.category !== '' &&
    product.price !== '' &&
    product.stock !== ''
  );
  
  // Generar código de barras aleatorio (solo para demostración)
  function generateBarcode() {
    const randomBarcode = '77' + Math.floor(100000000000 + Math.random() * 900000000000).toString().substring(0, 10);
    product.barcode = randomBarcode;
  }
  
  // Manejar envío del formulario
  async function handleSubmit() {
    if (!formIsValid) return;
    
    loading = true;
    
    try {
      // Simular envío a la API
      await new Promise(resolve => setTimeout(resolve, 1500));
      
      // Aquí iría la lógica para guardar en la base de datos
      console.log('Producto a guardar:', {
        ...product,
        price: parseFloat(product.price),
        cost: product.cost ? parseFloat(product.cost) : null,
        stock: parseInt(product.stock),
        minStock: parseInt(product.minStock)
      });
      
      // Mostrar mensaje de éxito
      success = true;
      
      // Limpiar formulario después de guardar
      setTimeout(() => {
        product = {
          name: '',
          description: '',
          category: '',
          price: '',
          cost: '',
          stock: '0',
          minStock: '5',
          barcode: '',
          supplier: '',
          location: '',
          requiresPrescription: false,
          expirationDate: ''
        };
        success = false;
      }, 3000);
      
    } catch (error) {
      console.error('Error al guardar el producto:', error);
      alert('Ocurrió un error al guardar el producto');
    } finally {
      loading = false;
    }
  }
  
  // Generar código de barras al cargar la página
  onMount(() => {
    generateBarcode();
  });
</script>

<div class="min-h-screen bg-gray-50 py-8">
  <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="bg-white shadow rounded-lg overflow-hidden">
      <!-- Encabezado -->
      <div class="px-6 py-5 border-b border-gray-200">
        <div class="flex items-center justify-between">
          <div>
            <h1 class="text-2xl font-bold text-gray-900">Agregar Producto al Inventario</h1>
            <p class="mt-1 text-sm text-gray-500">Complete la información del producto a agregar</p>
          </div>
          <div class="flex-shrink-0">
            <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-indigo-100 text-indigo-800">
              <svg class="-ml-1 mr-1.5 h-2 w-2 text-indigo-400" fill="currentColor" viewBox="0 0 8 8">
                <circle cx="4" cy="4" r="3" />
              </svg>
              Nuevo Producto
            </span>
          </div>
        </div>
      </div>
      
      <!-- Formulario -->
      <div class="px-6 py-6">
        {#if success}
          <div 
            in:fly={{ y: 20, duration: 300 }}
            class="rounded-md bg-green-50 p-4 mb-6"
          >
            <div class="flex">
              <div class="flex-shrink-0">
                <svg class="h-5 w-5 text-green-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                </svg>
              </div>
              <div class="ml-3">
                <p class="text-sm font-medium text-green-800">¡Producto agregado exitosamente!</p>
              </div>
            </div>
          </div>
        {/if}
        
        <form on:submit|preventDefault={handleSubmit} class="space-y-6">
          <div class="grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">
            <!-- Nombre del producto -->
            <div class="sm:col-span-4">
              <label for="name" class="block text-sm font-medium text-gray-700">
                Nombre del producto <span class="text-red-500">*</span>
              </label>
              <div class="mt-1">
                <input
                  type="text"
                  id="name"
                  bind:value={product.name}
                  class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md"
                  placeholder="Ej: Paracetamol 500mg"
                  required
                />
              </div>
            </div>
            
            <!-- Categoría -->
            <div class="sm:col-span-2">
              <label for="category" class="block text-sm font-medium text-gray-700">
                Categoría <span class="text-red-500">*</span>
              </label>
              <div class="mt-1">
                <select
                  id="category"
                  bind:value={product.category}
                  class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md"
                  required
                >
                  <option value="">Seleccionar categoría</option>
                  {#each categories as category}
                    <option value={category}>{category}</option>
                  {/each}
                </select>
              </div>
            </div>
            
            <!-- Descripción -->
            <div class="sm:col-span-6">
              <label for="description" class="block text-sm font-medium text-gray-700">
                Descripción
              </label>
              <div class="mt-1">
                <textarea
                  id="description"
                  rows="3"
                  bind:value={product.description}
                  class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md"
                  placeholder="Descripción detallada del producto"
                ></textarea>
              </div>
            </div>
            
            <!-- Precio y Costo -->
            <div class="sm:col-span-3">
              <label for="price" class="block text-sm font-medium text-gray-700">
                Precio de venta (S/) <span class="text-red-500">*</span>
              </label>
              <div class="mt-1 relative rounded-md shadow-sm">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <span class="text-gray-500 sm:text-sm">S/</span>
                </div>
                <input
                  type="number"
                  id="price"
                  bind:value={product.price}
                  step="0.01"
                  min="0"
                  class="focus:ring-indigo-500 focus:border-indigo-500 block w-full pl-10 sm:text-sm border-gray-300 rounded-md"
                  placeholder="0.00"
                  required
                />
              </div>
            </div>
            
            <div class="sm:col-span-3">
              <label for="cost" class="block text-sm font-medium text-gray-700">
                Costo (S/)
              </label>
              <div class="mt-1 relative rounded-md shadow-sm">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <span class="text-gray-500 sm:text-sm">S/</span>
                </div>
                <input
                  type="number"
                  id="cost"
                  bind:value={product.cost}
                  step="0.01"
                  min="0"
                  class="focus:ring-indigo-500 focus:border-indigo-500 block w-full pl-10 sm:text-sm border-gray-300 rounded-md"
                  placeholder="0.00"
                />
              </div>
            </div>
            
            <!-- Stock y Stock Mínimo -->
            <div class="sm:col-span-3">
              <label for="stock" class="block text-sm font-medium text-gray-700">
                Stock inicial <span class="text-red-500">*</span>
              </label>
              <div class="mt-1">
                <input
                  type="number"
                  id="stock"
                  bind:value={product.stock}
                  min="0"
                  class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md"
                  required
                />
              </div>
            </div>
            
            <div class="sm:col-span-3">
              <label for="minStock" class="block text-sm font-medium text-gray-700">
                Stock mínimo
              </label>
              <div class="mt-1">
                <input
                  type="number"
                  id="minStock"
                  bind:value={product.minStock}
                  min="0"
                  class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md"
                />
              </div>
            </div>
            
            <!-- Código de barras -->
            <div class="sm:col-span-4">
              <label for="barcode" class="block text-sm font-medium text-gray-700">
                Código de barras
              </label>
              <div class="mt-1 flex rounded-md shadow-sm">
                <input
                  type="text"
                  id="barcode"
                  bind:value={product.barcode}
                  class="focus:ring-indigo-500 focus:border-indigo-500 flex-1 block w-full rounded-none rounded-l-md sm:text-sm border-gray-300"
                  placeholder="Código de barras"
                />
                <button
                  type="button"
                  on:click={generateBarcode}
                  class="inline-flex items-center px-3 rounded-r-md border border-l-0 border-gray-300 bg-gray-50 text-gray-500 text-sm hover:bg-gray-100"
                  title="Generar nuevo código"
                >
                  <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                  </svg>
                </button>
              </div>
            </div>
            
            <!-- Fecha de vencimiento -->
            <div class="sm:col-span-2">
              <label for="expirationDate" class="block text-sm font-medium text-gray-700">
                Fecha de vencimiento
              </label>
              <div class="mt-1">
                <input
                  type="date"
                  id="expirationDate"
                  bind:value={product.expirationDate}
                  class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md"
                />
              </div>
            </div>
            
            <!-- Proveedor y Ubicación -->
            <div class="sm:col-span-3">
              <label for="supplier" class="block text-sm font-medium text-gray-700">
                Proveedor
              </label>
              <div class="mt-1">
                <select
                  id="supplier"
                  bind:value={product.supplier}
                  class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md"
                >
                  <option value="">Seleccionar proveedor</option>
                  {#each suppliers as supplier}
                    <option value={supplier}>{supplier}</option>
                  {/each}
                </select>
              </div>
            </div>
            
            <div class="sm:col-span-3">
              <label for="location" class="block text-sm font-medium text-gray-700">
                Ubicación en almacén
              </label>
              <div class="mt-1">
                <select
                  id="location"
                  bind:value={product.location}
                  class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md"
                >
                  <option value="">Seleccionar ubicación</option>
                  {#each locations as location}
                    <option value={location}>{location}</option>
                  {/each}
                </select>
              </div>
            </div>
            
            <!-- Checkbox para receta médica -->
            <div class="sm:col-span-6">
              <div class="flex items-start">
                <div class="flex items-center h-5">
                  <input
                    id="requiresPrescription"
                    type="checkbox"
                    bind:checked={product.requiresPrescription}
                    class="focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300 rounded"
                  />
                </div>
                <div class="ml-3 text-sm">
                  <label for="requiresPrescription" class="font-medium text-gray-700">
                    Requiere receta médica
                  </label>
                  <p class="text-gray-500">Marcar si este producto necesita receta médica para su venta.</p>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Botones de acción -->
          <div class="pt-5">
            <div class="flex justify-end">
              <a
                href="/inventory"
                class="bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
              >
                Cancelar
              </a>
              <button
                type="submit"
                disabled={!formIsValid || loading}
                class="ml-3 inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {#if loading}
                  <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  Guardando...
                {:else}
                  <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                  </svg>
                  Guardar Producto
                {/if}
              </button>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

<style>
  /* Estilos para los inputs de tipo number sin flechas */
  input[type=number]::-webkit-outer-spin-button,
  input[type=number]::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
  }
  
  input[type=number] {
    -moz-appearance: textfield;
  }
  
  /* Mejora la apariencia del selector de fecha en navegadores modernos */
  input[type=date]::-webkit-calendar-picker-indicator {
    cursor: pointer;
    opacity: 0.6;
  }
  
  input[type=date]:hover::-webkit-calendar-picker-indicator,
  input[type=date]:focus::-webkit-calendar-picker-indicator {
    opacity: 1;
  }
</style>
