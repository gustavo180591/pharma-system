<script lang="ts">
  import { onMount } from 'svelte';
  
  // Sample data - in a real app, this would come from your API
  let stats = [
    { name: 'Total Ventas Hoy', value: '$12,345', change: '+12%', changeType: 'increase' },
    { name: 'Productos en Stock', value: '1,234', change: '+5%', changeType: 'increase' },
    { name: 'Clientes Nuevos', value: '24', change: '-2%', changeType: 'decrease' },
    { name: 'Pedidos Pendientes', value: '8', change: '+3', changeType: 'neutral' },
  ];

  let recentSales = [
    { id: 1, customer: 'Juan Pérez', amount: '$1,234', status: 'Completado', date: '2023-11-15' },
    { id: 2, customer: 'María González', amount: '$567', status: 'Pendiente', date: '2023-11-15' },
    { id: 3, customer: 'Carlos López', amount: '$2,890', status: 'Completado', date: '2023-11-14' },
    { id: 4, customer: 'Ana Martínez', amount: '$1,234', status: 'Cancelado', date: '2023-11-14' },
    { id: 5, customer: 'Luis Rodríguez', amount: '$3,210', status: 'Completado', date: '2023-11-13' },
  ];

  let lowStockProducts = [
    { id: 1, name: 'Paracetamol 500mg', stock: 5, minStock: 10 },
    { id: 2, name: 'Ibuprofeno 400mg', stock: 3, minStock: 15 },
    { id: 3, name: 'Amoxicilina 500mg', stock: 7, minStock: 20 },
    { id: 4, name: 'Omeprazol 20mg', stock: 2, minStock: 10 },
  ];

  onMount(() => {
    // In a real app, you would fetch data here
    // Example:
    // fetch('/api/dashboard')
    //   .then(res => res.json())
    //   .then(data => {
    //     stats = data.stats;
    //     recentSales = data.recentSales;
    //     lowStockProducts = data.lowStockProducts;
    //   });
  });
</script>

<div class="space-y-8">
  <!-- Welcome header -->
  <div class="bg-white dark:bg-slate-800 shadow rounded-lg p-6">
    <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Bienvenido a PharmaSystem</h1>
    <p class="mt-1 text-gray-600 dark:text-gray-300">Panel de control y gestión de farmacia</p>
  </div>

  <!-- Stats -->
  <div class="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4">
    {#each stats as stat}
      <div class="bg-white dark:bg-slate-800 overflow-hidden shadow rounded-lg">
        <div class="px-4 py-5 sm:p-6">
          <dt class="text-sm font-medium text-gray-500 dark:text-gray-400 truncate">
            {stat.name}
          </dt>
          <dd class="mt-1 text-3xl font-semibold text-gray-900 dark:text-white">
            {stat.value}
          </dd>
          <div class="mt-2">
            {#if stat.changeType === 'increase'}
              <span class="inline-flex items-baseline px-2.5 py-0.5 rounded-full text-sm font-medium bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200">
                <svg class="-ml-1 mr-0.5 flex-shrink-0 self-center h-4 w-4 text-green-500" fill="currentColor" viewBox="0 0 20 20" aria-hidden="true">
                  <path fill-rule="evenodd" d="M5.293 9.707a1 1 0 010-1.414l4-4a1 1 0 011.414 0l4 4a1 1 0 01-1.414 1.414L11 7.414V15a1 1 0 11-2 0V7.414L6.707 9.707a1 1 0 01-1.414 0z" clip-rule="evenodd" />
                </svg>
                <span class="sr-only">Increased by</span>
                {stat.change}
              </span>
            {:else if stat.changeType === 'decrease'}
              <span class="inline-flex items-baseline px-2.5 py-0.5 rounded-full text-sm font-medium bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200">
                <svg class="-ml-1 mr-0.5 flex-shrink-0 self-center h-4 w-4 text-red-500" fill="currentColor" viewBox="0 0 20 20" aria-hidden="true">
                  <path fill-rule="evenodd" d="M14.707 10.293a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 111.414-1.414L9 12.586V5a1 1 0 012 0v7.586l2.293-2.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                </svg>
                <span class="sr-only">Decreased by</span>
                {stat.change}
              </span>
            {:else}
              <span class="inline-flex items-baseline px-2.5 py-0.5 rounded-full text-sm font-medium bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300">
                {stat.change}
              </span>
            {/if}
          </div>
        </div>
      </div>
    {/each}
  </div>

  <div class="grid grid-cols-1 gap-5 lg:grid-cols-2">
    <!-- Recent Sales -->
    <div class="bg-white dark:bg-slate-800 shadow rounded-lg overflow-hidden">
      <div class="px-4 py-5 sm:px-6 border-b border-gray-200 dark:border-slate-700">
        <h3 class="text-lg font-medium leading-6 text-gray-900 dark:text-white">Ventas Recientes</h3>
      </div>
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200 dark:divide-slate-700">
          <thead class="bg-gray-50 dark:bg-slate-800">
            <tr>
              <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">Cliente</th>
              <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">Monto</th>
              <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">Estado</th>
              <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">Fecha</th>
            </tr>
          </thead>
          <tbody class="bg-white dark:bg-slate-800 divide-y divide-gray-200 dark:divide-slate-700">
            {#each recentSales as sale}
              <tr class="hover:bg-gray-50 dark:hover:bg-slate-700">
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 dark:text-white">
                  {sale.customer}
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400">
                  {sale.amount}
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  {#if sale.status === 'Completado'}
                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200">
                      {sale.status}
                    </span>
                  {:else if sale.status === 'Pendiente'}
                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200">
                      {sale.status}
                    </span>
                  {:else}
                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200">
                      {sale.status}
                    </span>
                  {/if}
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400">
                  {sale.date}
                </td>
              </tr>
            {/each}
          </tbody>
        </table>
      </div>
      <div class="bg-gray-50 dark:bg-slate-800 px-4 py-3 flex items-center justify-between border-t border-gray-200 dark:border-slate-700 sm:px-6">
        <div class="flex-1 flex justify-between sm:hidden">
          <a href="/sales" class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
            Ver todo
          </a>
        </div>
        <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
          <div>
            <p class="text-sm text-gray-700 dark:text-gray-300">
              Mostrando <span class="font-medium">1</span> a <span class="font-medium">5</span> de <span class="font-medium">24</span> resultados
            </p>
          </div>
          <div>
            <a href="/sales" class="text-sm font-medium text-blue-600 hover:text-blue-500 dark:text-blue-400 dark:hover:text-blue-300">
              Ver todas las ventas →
            </a>
          </div>
        </div>
      </div>
    </div>

    <!-- Low Stock Products -->
    <div class="bg-white dark:bg-slate-800 shadow rounded-lg overflow-hidden">
      <div class="px-4 py-5 sm:px-6 border-b border-gray-200 dark:border-slate-700">
        <h3 class="text-lg font-medium leading-6 text-gray-900 dark:text-white">Productos con Stock Bajo</h3>
      </div>
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200 dark:divide-slate-700">
          <thead class="bg-gray-50 dark:bg-slate-800">
            <tr>
              <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">Producto</th>
              <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">Stock Actual</th>
              <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">Mínimo</th>
              <th scope="col" class="relative px-6 py-3">
                <span class="sr-only">Acciones</span>
              </th>
            </tr>
          </thead>
          <tbody class="bg-white dark:bg-slate-800 divide-y divide-gray-200 dark:divide-slate-700">
            {#each lowStockProducts as product}
              <tr class="hover:bg-gray-50 dark:hover:bg-slate-700">
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="text-sm font-medium text-gray-900 dark:text-white">{product.name}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="text-sm text-gray-900 dark:text-white">{product.stock}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="text-sm text-gray-500 dark:text-gray-400">{product.minStock}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                  <a href={`/inventory/${product.id}/edit`} class="text-blue-600 hover:text-blue-900 dark:text-blue-400 dark:hover:text-blue-300">Reponer</a>
                </td>
              </tr>
            {/each}
          </tbody>
        </table>
      </div>
      <div class="bg-gray-50 dark:bg-slate-800 px-4 py-3 flex items-center justify-between border-t border-gray-200 dark:border-slate-700 sm:px-6">
        <div class="flex-1 flex justify-between sm:hidden">
          <a href="/inventory" class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
            Ver todo
          </a>
        </div>
        <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
          <div>
            <p class="text-sm text-gray-700 dark:text-gray-300">
              Mostrando <span class="font-medium">{lowStockProducts.length}</span> de <span class="font-medium">{lowStockProducts.length}</span> productos con stock bajo
            </p>
          </div>
          <div>
            <a href="/inventory" class="text-sm font-medium text-blue-600 hover:text-blue-500 dark:text-blue-400 dark:hover:text-blue-300">
              Ver inventario completo →
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Quick Actions -->
  <div class="bg-white dark:bg-slate-800 shadow rounded-lg overflow-hidden">
    <div class="px-4 py-5 sm:p-6">
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-4">Acciones Rápidas</h3>
      <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <a href="/sales/new" class="relative bg-white dark:bg-slate-700 p-6 rounded-lg border border-gray-200 dark:border-slate-600 shadow-sm flex items-center space-x-3 hover:border-blue-500 dark:hover:border-blue-400 focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-blue-500 transition-colors">
          <div class="flex-shrink-0 bg-blue-500 rounded-md p-3">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
            </svg>
          </div>
          <div class="flex-1 min-w-0">
            <span class="absolute inset-0" aria-hidden="true"></span>
            <p class="text-sm font-medium text-gray-900 dark:text-white">Nueva Venta</p>
            <p class="text-sm text-gray-500 dark:text-gray-400 truncate">Registrar una nueva venta</p>
          </div>
        </a>
        
        <a href="/inventory/add" class="relative bg-white dark:bg-slate-700 p-6 rounded-lg border border-gray-200 dark:border-slate-600 shadow-sm flex items-center space-x-3 hover:border-green-500 dark:hover:border-green-400 focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-green-500 transition-colors">
          <div class="flex-shrink-0 bg-green-500 rounded-md p-3">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v3m0 0v3m0-3h3m-3 0H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
          <div class="flex-1 min-w-0">
            <span class="absolute inset-0" aria-hidden="true"></span>
            <p class="text-sm font-medium text-gray-900 dark:text-white">Agregar Stock</p>
            <p class="text-sm text-gray-500 dark:text-gray-400 truncate">Añadir productos al inventario</p>
          </div>
        </a>
        
        <a href="/products/new" class="relative bg-white dark:bg-slate-700 p-6 rounded-lg border border-gray-200 dark:border-slate-600 shadow-sm flex items-center space-x-3 hover:border-purple-500 dark:hover:border-purple-400 focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-purple-500 transition-colors">
          <div class="flex-shrink-0 bg-purple-500 rounded-md p-3">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
            </svg>
          </div>
          <div class="flex-1 min-w-0">
            <span class="absolute inset-0" aria-hidden="true"></span>
            <p class="text-sm font-medium text-gray-900 dark:text-white">Nuevo Producto</p>
            <p class="text-sm text-gray-500 dark:text-gray-400 truncate">Añadir un nuevo producto</p>
          </div>
        </a>
        
        <a href="/reports" class="relative bg-white dark:bg-slate-700 p-6 rounded-lg border border-gray-200 dark:border-slate-600 shadow-sm flex items-center space-x-3 hover:border-yellow-500 dark:hover:border-yellow-400 focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-yellow-500 transition-colors">
          <div class="flex-shrink-0 bg-yellow-500 rounded-md p-3">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
          </div>
          <div class="flex-1 min-w-0">
            <span class="absolute inset-0" aria-hidden="true"></span>
            <p class="text-sm font-medium text-gray-900 dark:text-white">Reportes</p>
            <p class="text-sm text-gray-500 dark:text-gray-400 truncate">Ver reportes y análisis</p>
          </div>
        </a>
      </div>
    </div>
  </div>
</div>
