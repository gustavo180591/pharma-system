<script lang="ts">
  import { page } from '$app/stores';
  import { onMount } from 'svelte';
  
  let product = {
    id: 0,
    name: '',
    description: 'Descripción detallada del producto con información sobre sus usos, composición y recomendaciones.',
    price: 0,
    stock: 0,
    category: '',
    sku: 'SKU123456',
    laboratory: 'Laboratorio Ejemplo S.A.',
    requiresPrescription: false
  };

  // En una aplicación real, esto vendría de una API
  const products = {
    1: { id: 1, name: 'Paracetamol 500mg', price: 5.99, stock: 100, category: 'Analgésico', description: 'Alivia el dolor y reduce la fiebre.' },
    2: { id: 2, name: 'Ibuprofeno 400mg', price: 7.50, stock: 75, category: 'Antiinflamatorio', description: 'Reduce la inflamación y alivia el dolor.' },
    3: { id: 3, name: 'Omeprazol 20mg', price: 12.00, stock: 50, category: 'Protector gástrico', description: 'Reduce la producción de ácido estomacal.' },
    4: { id: 4, name: 'Amoxicilina 500mg', price: 15.75, stock: 30, category: 'Antibiótico', description: 'Tratamiento para infecciones bacterianas.' },
    5: { id: 5, name: 'Loratadina 10mg', price: 8.25, stock: 60, category: 'Antihistamínico', description: 'Alivia los síntomas de alergias.' },
  };

  onMount(() => {
    // Obtener el ID de la URL
    const id = parseInt($page.params.id);
    // Buscar el producto (en una app real, esto sería una llamada a la API)
    product = products[id] || product;
  });
</script>

<div class="container mx-auto px-4 py-8">
  <a href="/products" class="text-indigo-600 hover:text-indigo-800 mb-4 inline-flex items-center">
    <svg class="w-5 h-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
    </svg>
    Volver al listado
  </a>

  <div class="bg-white shadow-lg rounded-lg overflow-hidden">
    <div class="md:flex">
      <div class="md:flex-shrink-0 bg-gray-200 p-8 flex items-center justify-center">
        <svg class="h-48 w-full text-gray-300 md:w-48" fill="currentColor" viewBox="0 0 24 24">
          <path d="M4 4v16h16V4H4zm12 12H8V8h8v8z" />
        </svg>
      </div>
      <div class="p-8">
        <div class="uppercase tracking-wide text-sm text-indigo-600 font-semibold">{product.category}</div>
        <h1 class="text-2xl font-bold text-gray-800 mt-1">{product.name}</h1>
        
        <div class="mt-4">
          <span class="text-3xl font-bold text-gray-900">${product.price.toFixed(2)}</span>
          <span class="ml-2 text-sm text-gray-600">por unidad</span>
        </div>

        <div class="mt-4">
          <span class="text-sm font-medium text-gray-900">Disponibilidad: </span>
          <span class={`text-sm font-medium ${product.stock > 0 ? 'text-green-600' : 'text-red-600'}`}>
            {product.stock > 0 ? 'En stock' : 'Sin stock'} ({product.stock} unidades)
          </span>
        </div>

        <div class="mt-4">
          <span class="text-sm font-medium text-gray-900">SKU: </span>
          <span class="text-sm text-gray-600">{product.sku}</span>
        </div>

        <div class="mt-4">
          <span class="text-sm font-medium text-gray-900">Laboratorio: </span>
          <span class="text-sm text-gray-600">{product.laboratory}</span>
        </div>

        {#if product.requiresPrescription}
          <div class="mt-2">
            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
              Requiere receta médica
            </span>
          </div>
        {/if}

        <div class="mt-6">
          <h2 class="text-lg font-medium text-gray-900">Descripción</h2>
          <p class="mt-2 text-gray-600">{product.description}</p>
        </div>

        <div class="mt-8 flex space-x-4">
          <button class="bg-indigo-600 text-white px-6 py-2 rounded-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
            Agregar al carrito
          </button>
          <button class="text-gray-700 bg-white border border-gray-300 px-6 py-2 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
            Editar producto
          </button>
        </div>
      </div>
    </div>
  </div>
</div>
