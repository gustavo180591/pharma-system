<script lang="ts">
  import { onMount } from 'svelte';
  import { fade, fly } from 'svelte/transition';
  import { Chart, registerables } from 'chart.js';
  
  // Registrar componentes de Chart.js
  Chart.register(...registerables);
  
  // Estados
  let loading = true;
  let activeTab = 'sales';
  let dateRange = 'week';
  let startDate = '';
  let endDate = '';
  
  // Datos de ejemplo para los reportes
  let reports = {
    sales: {
      total: 0,
      count: 0,
      average: 0,
      chartData: {},
      recent: []
    },
    inventory: {
      lowStock: [],
      topSelling: [],
      expired: []
    },
    financial: {
      revenue: 0,
      expenses: 0,
      profit: 0,
      chartData: {}
    }
  };
  
  // Inicializar fechas
  function initializeDates() {
    const end = new Date();
    const start = new Date();
    
    switch (dateRange) {
      case 'today':
        start.setHours(0, 0, 0, 0);
        break;
      case 'week':
        start.setDate(start.getDate() - 7);
        break;
      case 'month':
        start.setMonth(start.getMonth() - 1);
        break;
      case 'year':
        start.setFullYear(start.getFullYear() - 1);
        break;
      case 'custom':
        // Las fechas personalizadas se manejarán por los inputs
        return;
    }
    
    startDate = formatDate(start);
    endDate = formatDate(end);
  }
  
  // Formatear fecha para input type="date"
  function formatDate(date) {
    return date.toISOString().split('T')[0];
  }
  
  // Cargar datos del reporte
  async function loadReportData() {
    loading = true;
    
    try {
      // Simular carga de datos de la API
      await new Promise(resolve => setTimeout(resolve, 1000));
      
      // Datos de ejemplo para ventas
      reports.sales = {
        total: 12540.75,
        count: 342,
        average: 36.67,
        chartData: {
          labels: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'],
          datasets: [{
            label: 'Ventas (S/)',
            data: [1200, 1900, 1500, 2000, 1800, 2500, 1640],
            backgroundColor: 'rgba(79, 70, 229, 0.1)',
            borderColor: 'rgba(79, 70, 229, 1)',
            borderWidth: 2,
            tension: 0.3,
            fill: true
          }]
        },
        recent: [
          { id: 1001, date: '2023-11-10 15:30', total: 125.50, items: 3, payment: 'Tarjeta' },
          { id: 1002, date: '2023-11-10 14:15', total: 78.90, items: 2, payment: 'Efectivo' },
          { id: 1003, date: '2023-11-10 13:45', total: 210.75, items: 5, payment: 'Yape' },
          { id: 1004, date: '2023-11-10 12:20', total: 45.00, items: 1, payment: 'Efectivo' },
          { id: 1005, date: '2023-11-10 11:05', total: 92.30, items: 4, payment: 'Transferencia' }
        ]
      };
      
      // Datos de ejemplo para inventario
      reports.inventory = {
        lowStock: [
          { id: 'P001', name: 'Paracetamol 500mg', stock: 3, minStock: 10 },
          { id: 'P005', name: 'Amoxicilina 250mg', stock: 5, minStock: 15 },
          { id: 'P012', name: 'Ibuprofeno 400mg', stock: 8, minStock: 20 },
          { id: 'P018', name: 'Omeprazol 20mg', stock: 2, minStock: 10 },
          { id: 'P022', name: 'Loratadina 10mg', stock: 4, minStock: 12 }
        ],
        topSelling: [
          { id: 'P001', name: 'Paracetamol 500mg', sold: 150, revenue: 2250.00 },
          { id: 'P003', name: 'Ibuprofeno 400mg', sold: 120, revenue: 1800.00 },
          { id: 'P008', name: 'Omeprazol 20mg', sold: 95, revenue: 2375.00 },
          { id: 'P005', name: 'Amoxicilina 250mg', sold: 85, revenue: 2975.00 },
          { id: 'P012', name: 'Loratadina 10mg', sold: 75, revenue: 1125.00 }
        ],
        expired: [
          { id: 'P015', name: 'Diclofenaco 50mg', quantity: 12, expiryDate: '2023-12-15' },
          { id: 'P022', name: 'Loratadina 10mg', quantity: 8, expiryDate: '2023-12-20' },
          { id: 'P007', name: 'Ranitidina 150mg', quantity: 5, expiryDate: '2023-12-25' }
        ]
      };
      
      // Datos de ejemplo para finanzas
      reports.financial = {
        revenue: 12540.75,
        expenses: 8560.30,
        profit: 3980.45,
        chartData: {
          labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
          datasets: [
            {
              label: 'Ingresos',
              data: [9800, 10200, 11000, 10800, 11500, 12000, 11800, 12200, 12540, 13000, 12800, 13500],
              borderColor: 'rgba(79, 70, 229, 1)',
              backgroundColor: 'rgba(79, 70, 229, 0.1)',
              tension: 0.3,
              fill: true
            },
            {
              label: 'Gastos',
              data: [7200, 7500, 7800, 8000, 8200, 8400, 8500, 8600, 8560, 8700, 8800, 9000],
              borderColor: 'rgba(239, 68, 68, 1)',
              backgroundColor: 'rgba(239, 68, 68, 0.1)',
              tension: 0.3,
              fill: true
            }
          ]
        }
      };
      
      // Inicializar gráficos después de cargar los datos
      initializeCharts();
      
    } catch (error) {
      console.error('Error al cargar los reportes:', error);
    } finally {
      loading = false;
    }
  }
  
  // Inicializar gráficos
  let salesChart, financialChart;
  
  function initializeCharts() {
    // Destruir gráficos existentes
    if (salesChart) salesChart.destroy();
    if (financialChart) financialChart.destroy();
    
    // Gráfico de ventas
    const salesCtx = document.getElementById('salesChart');
    if (salesCtx) {
      salesChart = new Chart(salesCtx, {
        type: 'line',
        data: reports.sales.chartData,
        options: {
          responsive: true,
          plugins: {
            legend: {
              position: 'top',
            },
            tooltip: {
              mode: 'index',
              intersect: false,
            }
          },
          scales: {
            y: {
              beginAtZero: true,
              ticks: {
                callback: function(value) {
                  return 'S/ ' + value;
                }
              }
            }
          }
        },
      });
    }
    
    // Gráfico financiero
    const financialCtx = document.getElementById('financialChart');
    if (financialCtx) {
      financialChart = new Chart(financialCtx, {
        type: 'line',
        data: reports.financial.chartData,
        options: {
          responsive: true,
          interaction: {
            mode: 'index',
            intersect: false,
          },
          plugins: {
            legend: {
              position: 'top',
            },
            tooltip: {
              callbacks: {
                label: function(context) {
                  let label = context.dataset.label || '';
                  if (label) {
                    label += ': ';
                  }
                  if (context.parsed.y !== null) {
                    label += new Intl.NumberFormat('es-PE', { style: 'currency', currency: 'PEN' }).format(context.parsed.y);
                  }
                  return label;
                }
              }
            }
          },
          scales: {
            y: {
              beginAtZero: true,
              ticks: {
                callback: function(value) {
                  return 'S/ ' + value;
                }
              }
            }
          }
        },
      });
    }
  }
  
  // Manejar cambio de pestaña
  function changeTab(tab) {
    activeTab = tab;
    // Re-inicializar gráficos cuando la pestaña se vuelve visible
    if (tab === 'sales' || tab === 'financial') {
      setTimeout(initializeCharts, 100);
    }
  }
  
  // Manejar cambio de rango de fechas
  function handleDateRangeChange() {
    if (dateRange !== 'custom') {
      initializeDates();
    }
    // Recargar datos con el nuevo rango de fechas
    loadReportData();
  }
  
  // Inicializar al cargar el componente
  onMount(() => {
    initializeDates();
    loadReportData();
    
    // Asegurarse de que los gráficos se redimensionen correctamente
    window.addEventListener('resize', initializeCharts);
    
    return () => {
      window.removeEventListener('resize', initializeCharts);
      if (salesChart) salesChart.destroy();
      if (financialChart) financialChart.destroy();
    };
  });
  
  // Formatear moneda
  function formatCurrency(amount) {
    return new Intl.NumberFormat('es-PE', { style: 'currency', currency: 'PEN' }).format(amount);
  }
  
  // Formatear fecha
  function formatDateString(dateString) {
    const options = { year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' };
    return new Date(dateString).toLocaleDateString('es-PE', options);
  }
  
  // Calcular porcentaje de stock
  function getStockPercentage(stock, minStock) {
    const percentage = (stock / minStock) * 100;
    return Math.min(100, Math.max(0, Math.round(percentage)));
  }
  
  // Obtener clase de color según el nivel de stock
  function getStockColor(percentage) {
    if (percentage < 25) return 'bg-red-100 text-red-800';
    if (percentage < 50) return 'bg-yellow-100 text-yellow-800';
    if (percentage < 75) return 'bg-blue-100 text-blue-800';
    return 'bg-green-100 text-green-800';
  }
</script>

<div class="min-h-screen bg-gray-50 py-8">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <!-- Encabezado -->
    <div class="md:flex md:items-center md:justify-between mb-8">
      <div class="flex-1 min-w-0">
        <h2 class="text-2xl font-bold leading-7 text-gray-900 sm:text-3xl sm:truncate">Reportes</h2>
        <p class="mt-1 text-sm text-gray-500">Visualiza y analiza el rendimiento de tu farmacia</p>
      </div>
      <div class="mt-4 flex md:mt-0 md:ml-4">
        <div class="relative">
          <select 
            bind:value={dateRange} 
            on:change={handleDateRangeChange}
            class="block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md"
          >
            <option value="today">Hoy</option>
            <option value="week">Últimos 7 días</option>
            <option value="month">Últimos 30 días</option>
            <option value="year">Último año</option>
            <option value="custom">Personalizado</option>
          </select>
        </div>
        {#if dateRange === 'custom'}
          <div class="ml-2 flex">
            <input 
              type="date" 
              bind:value={startDate}
              class="block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-l-md"
            />
            <span class="inline-flex items-center px-3 bg-gray-50 text-gray-500 border border-l-0 border-gray-300">
              a
            </span>
            <input 
              type="date" 
              bind:value={endDate}
              class="block w-full pl-3 pr-10 py-2 text-base border-gray-300 border-l-0 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-r-md"
            />
            <button 
              on:click={loadReportData}
              class="ml-2 inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            >
              Aplicar
            </button>
          </div>
        {/if}
        <button 
          type="button" 
          class="ml-3 inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
        >
          <svg class="-ml-1 mr-2 h-5 w-5 text-gray-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M3 17a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zm3.293-7.707a1 1 0 011.414 0L9 10.586V3a1 1 0 112 0v7.586l1.293-1.293a1 1 0 111.414 1.414l-3 3a1 1 0 01-1.414 0l-3-3a1 1 0 010-1.414z" clip-rule="evenodd" />
          </svg>
          Exportar
        </button>
      </div>
    </div>
    
    <!-- Pestañas -->
    <div class="border-b border-gray-200 mb-6">
      <nav class="-mb-px flex space-x-8">
        <button
          on:click={() => changeTab('sales')}
          class="whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm {activeTab === 'sales' ? 'border-indigo-500 text-indigo-600' : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'}"
        >
          Ventas
        </button>
        <button
          on:click={() => changeTab('inventory')}
          class="whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm {activeTab === 'inventory' ? 'border-indigo-500 text-indigo-600' : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'}"
        >
          Inventario
        </button>
        <button
          on:click={() => changeTab('financial')}
          class="whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm {activeTab === 'financial' ? 'border-indigo-500 text-indigo-600' : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'}"
        >
          Financiero
        </button>
      </nav>
    </div>
    
    <!-- Contenido de los reportes -->
    {#if loading}
      <div class="flex justify-center items-center py-12">
        <div class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-indigo-500"></div>
      </div>
    {:else}
      <!-- Reporte de Ventas -->
      {#if activeTab === 'sales'}
        <div class="bg-white shadow overflow-hidden sm:rounded-lg mb-8">
          <div class="px-4 py-5 sm:px-6">
            <h3 class="text-lg leading-6 font-medium text-gray-900">Resumen de Ventas</h3>
            <p class="mt-1 max-w-2xl text-sm text-gray-500">Estadísticas y tendencias de ventas</p>
          </div>
          <div class="border-t border-gray-200 px-4 py-5 sm:p-0">
            <dl class="sm:divide-y sm:divide-gray-200">
              <div class="py-4 sm:py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                <dt class="text-sm font-medium text-gray-500">Total de ventas</dt>
                <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                  <div class="text-2xl font-semibold">{formatCurrency(reports.sales.total)}</div>
                  <div class="text-sm text-gray-500">{reports.sales.count} transacciones</div>
                </dd>
              </div>
              <div class="py-4 sm:py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                <dt class="text-sm font-medium text-gray-500">Ticket promedio</dt>
                <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                  <div class="text-xl font-semibold">{formatCurrency(reports.sales.average)}</div>
                </dd>
              </div>
              <div class="py-4 sm:py-5 sm:grid sm:grid-cols-1 sm:gap-4 sm:px-6">
                <dt class="text-sm font-medium text-gray-500 mb-4">Tendencia de ventas</dt>
                <dd class="mt-1 text-sm text-gray-900">
                  <div class="h-64">
                    <canvas id="salesChart"></canvas>
                  </div>
                </dd>
              </div>
            </dl>
          </div>
        </div>
        
        <!-- Últimas ventas -->
        <div class="bg-white shadow overflow-hidden sm:rounded-lg">
          <div class="px-4 py-5 sm:px-6">
            <h3 class="text-lg leading-6 font-medium text-gray-900">Últimas Ventas</h3>
          </div>
          <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-50">
                <tr>
                  <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                  <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Fecha</th>
                  <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Productos</th>
                  <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Total</th>
                  <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Pago</th>
                  <th scope="col" class="relative px-6 py-3">
                    <span class="sr-only">Acciones</span>
                  </th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                {#each reports.sales.recent as sale}
                  <tr class="hover:bg-gray-50">
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">#{sale.id}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{formatDateString(sale.date)}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{sale.items} productos</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{formatCurrency(sale.total)}</td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                        {sale.payment}
                      </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                      <a href={`/sales/${sale.id}`} class="text-indigo-600 hover:text-indigo-900">Ver detalle</a>
                    </td>
                  </tr>
                {/each}
              </tbody>
            </table>
          </div>
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
                  Mostrando <span class="font-medium">1</span> a <span class="font-medium">5</span> de <span class="font-medium">342</span> resultados
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
                  <a href="#" class="bg-white border-gray-300 text-gray-500 hover:bg-gray-50 hidden md:inline-flex relative items-center px-4 py-2 border text-sm font-medium">
                    3
                  </a>
                  <span class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700">
                    ...
                  </span>
                  <a href="#" class="bg-white border-gray-300 text-gray-500 hover:bg-gray-50 hidden md:inline-flex relative items-center px-4 py-2 border text-sm font-medium">
                    8
                  </a>
                  <a href="#" class="bg-white border-gray-300 text-gray-500 hover:bg-gray-50 relative inline-flex items-center px-4 py-2 border text-sm font-medium">
                    9
                  </a>
                  <a href="#" class="bg-white border-gray-300 text-gray-500 hover:bg-gray-50 relative inline-flex items-center px-4 py-2 border text-sm font-medium">
                    10
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
        </div>
      
      <!-- Reporte de Inventario -->
      {:else if activeTab === 'inventory'}
        <div class="grid grid-cols-1 gap-6 lg:grid-cols-2">
          <!-- Bajo stock -->
          <div class="bg-white shadow overflow-hidden sm:rounded-lg">
            <div class="px-4 py-5 sm:px-6 border-b border-gray-200">
              <h3 class="text-lg leading-6 font-medium text-gray-900">Productos con Bajo Stock</h3>
              <p class="mt-1 max-w-2xl text-sm text-gray-500">Productos que están por debajo del stock mínimo</p>
            </div>
            <div class="overflow-hidden">
              <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                  <tr>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Producto</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Stock</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Mínimo</th>
                    <th scope="col" class="relative px-6 py-3">
                      <span class="sr-only">Acciones</span>
                    </th>
                  </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                  {#each reports.inventory.lowStock as product}
                    <tr class="hover:bg-gray-50">
                      <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm font-medium text-gray-900">{product.name}</div>
                        <div class="text-sm text-gray-500">{product.id}</div>
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap">
                        <div class="w-full bg-gray-200 rounded-full h-2.5">
                          {#const percentage = getStockPercentage(product.stock, product.minStock)}
                          <div class="h-2.5 rounded-full {getStockColor(percentage)}" style={`width: ${percentage}%`}></div>
                        </div>
                        <div class="text-sm text-gray-500 mt-1">{product.stock} unidades</div>
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {product.minStock} unidades
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                        <a href={`/inventory/${product.id}/edit`} class="text-indigo-600 hover:text-indigo-900">Reabastecer</a>
                      </td>
                    </tr>
                  {/each}
                </tbody>
              </table>
            </div>
            <div class="bg-gray-50 px-4 py-3 text-right sm:px-6">
              <a href="/inventory/low-stock" class="text-sm font-medium text-indigo-600 hover:text-indigo-500">Ver todos los productos con bajo stock</a>
            </div>
          </div>
          
          <!-- Productos más vendidos -->
          <div class="bg-white shadow overflow-hidden sm:rounded-lg">
            <div class="px-4 py-5 sm:px-6 border-b border-gray-200">
              <h3 class="text-lg leading-6 font-medium text-gray-900">Productos Más Vendidos</h3>
              <p class="mt-1 max-w-2xl text-sm text-gray-500">Productos con mayor cantidad de ventas</p>
            </div>
            <div class="overflow-hidden">
              <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                  <tr>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Producto</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Vendidos</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Ingresos</th>
                  </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                  {#each reports.inventory.topSelling as product}
                    <tr class="hover:bg-gray-50">
                      <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm font-medium text-gray-900">{product.name}</div>
                        <div class="text-sm text-gray-500">{product.id}</div>
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm text-gray-900">{product.sold} unidades</div>
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                        {formatCurrency(product.revenue)}
                      </td>
                    </tr>
                  {/each}
                </tbody>
              </table>
            </div>
            <div class="bg-gray-50 px-4 py-3 text-right sm:px-6">
              <a href="/reports/top-products" class="text-sm font-medium text-indigo-600 hover:text-indigo-500">Ver informe completo</a>
            </div>
          </div>
          
          <!-- Próximos a vencer -->
          <div class="bg-white shadow overflow-hidden sm:rounded-lg lg:col-span-2">
            <div class="px-4 py-5 sm:px-6 border-b border-gray-200">
              <h3 class="text-lg leading-6 font-medium text-gray-900">Próximos a Vencer</h3>
              <p class="mt-1 max-w-2xl text-sm text-gray-500">Productos que vencerán pronto</p>
            </div>
            <div class="overflow-x-auto">
              <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                  <tr>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Producto</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Cantidad</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Vence</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Días restantes</th>
                    <th scope="col" class="relative px-6 py-3">
                      <span class="sr-only">Acciones</span>
                    </th>
                  </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                  {#each reports.inventory.expired as product}
                    {#const expiryDate = new Date(product.expiryDate);
                      const today = new Date();
                      const diffTime = expiryDate - today;
                      const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                      let statusClass = '';
                      let statusText = '';
                      
                      if (diffDays < 0) {
                        statusClass = 'bg-red-100 text-red-800';
                        statusText = 'Vencido';
                      } else if (diffDays <= 30) {
                        statusClass = 'bg-yellow-100 text-yellow-800';
                        statusText = `Vence en ${diffDays} días`;
                      } else {
                        statusClass = 'bg-green-100 text-green-800';
                        statusText = `Vence en ${diffDays} días`;
                      }
                    }
                    <tr class="hover:bg-gray-50">
                      <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm font-medium text-gray-900">{product.name}</div>
                        <div class="text-sm text-gray-500">{product.id}</div>
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {product.quantity} unidades
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {new Date(product.expiryDate).toLocaleDateString('es-PE', { day: '2-digit', month: 'short', year: 'numeric' })}
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap">
                        <span class={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${statusClass}`}>
                          {statusText}
                        </span>
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                        <a href="#" class="text-indigo-600 hover:text-indigo-900">Ajustar</a>
                      </td>
                    </tr>
                  {/each}
                </tbody>
              </table>
            </div>
            <div class="bg-gray-50 px-4 py-3 text-right sm:px-6">
              <a href="/inventory/expiring" class="text-sm font-medium text-indigo-600 hover:text-indigo-500">Ver todos los productos próximos a vencer</a>
            </div>
          </div>
        </div>
      
      <!-- Reporte Financiero -->
      {:else if activeTab === 'financial'}
        <div class="grid grid-cols-1 gap-6 lg:grid-cols-3">
          <!-- Ingresos -->
          <div class="bg-white overflow-hidden shadow rounded-lg">
            <div class="px-4 py-5 sm:p-6">
              <div class="flex items-center">
                <div class="flex-shrink-0 bg-indigo-500 rounded-md p-3">
                  <svg class="h-6 w-6 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
                <div class="ml-5 w-0 flex-1">
                  <dl>
                    <dt class="text-sm font-medium text-gray-500 truncate">Ingresos Totales</dt>
                    <dd class="flex items-baseline">
                      <div class="text-2xl font-semibold text-gray-900">
                        {formatCurrency(reports.financial.revenue)}
                      </div>
                      <div class="ml-2 flex items-baseline text-sm font-semibold text-green-600">
                        <svg class="self-center flex-shrink-0 h-5 w-5 text-green-500" fill="currentColor" viewBox="0 0 20 20" aria-hidden="true">
                          <path fill-rule="evenodd" d="M5.293 9.707a1 1 0 010-1.414l4-4a1 1 0 011.414 0l4 4a1 1 0 01-1.414 1.414L11 7.414V15a1 1 0 11-2 0V7.414L6.707 9.707a1 1 0 01-1.414 0z" clip-rule="evenodd" />
                        </svg>
                        <span class="sr-only">Aumentó en</span>
                        12%
                      </div>
                    </dd>
                  </dl>
                </div>
              </div>
            </div>
            <div class="bg-gray-50 px-4 py-4 sm:px-6">
              <div class="text-sm">
                <a href="#" class="font-medium text-indigo-600 hover:text-indigo-500"> Ver detalles<span class="sr-only"> Ingresos totales</span></a>
              </div>
            </div>
          </div>
          
          <!-- Gastos -->
          <div class="bg-white overflow-hidden shadow rounded-lg">
            <div class="px-4 py-5 sm:p-6">
              <div class="flex items-center">
                <div class="flex-shrink-0 bg-red-500 rounded-md p-3">
                  <svg class="h-6 w-6 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                  </svg>
                </div>
                <div class="ml-5 w-0 flex-1">
                  <dl>
                    <dt class="text-sm font-medium text-gray-500 truncate">Gastos Totales</dt>
                    <dd class="flex items-baseline">
                      <div class="text-2xl font-semibold text-gray-900">
                        {formatCurrency(reports.financial.expenses)}
                      </div>
                      <div class="ml-2 flex items-baseline text-sm font-semibold text-red-600">
                        <svg class="self-center flex-shrink-0 h-5 w-5 text-red-500" fill="currentColor" viewBox="0 0 20 20" aria-hidden="true">
                          <path fill-rule="evenodd" d="M14.707 10.293a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 111.414-1.414L9 12.586V5a1 1 0 012 0v7.586l2.293-2.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                        </svg>
                        <span class="sr-only">Aumentó en</span>
                        8.2%
                      </div>
                    </dd>
                  </dl>
                </div>
              </div>
            </div>
            <div class="bg-gray-50 px-4 py-4 sm:px-6">
              <div class="text-sm">
                <a href="#" class="font-medium text-indigo-600 hover:text-indigo-500"> Ver detalles<span class="sr-only"> Gastos totales</span></a>
              </div>
            </div>
          </div>
          
          <!-- Utilidad -->
          <div class="bg-white overflow-hidden shadow rounded-lg">
            <div class="px-4 py-5 sm:p-6">
              <div class="flex items-center">
                <div class="flex-shrink-0 bg-green-500 rounded-md p-3">
                  <svg class="h-6 w-6 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                  </svg>
                </div>
                <div class="ml-5 w-0 flex-1">
                  <dl>
                    <dt class="text-sm font-medium text-gray-500 truncate">Utilidad Neta</dt>
                    <dd class="flex items-baseline">
                      <div class="text-2xl font-semibold text-gray-900">
                        {formatCurrency(reports.financial.profit)}
                      </div>
                      <div class="ml-2 flex items-baseline text-sm font-semibold text-green-600">
                        <svg class="self-center flex-shrink-0 h-5 w-5 text-green-500" fill="currentColor" viewBox="0 0 20 20" aria-hidden="true">
                          <path fill-rule="evenodd" d="M5.293 9.707a1 1 0 010-1.414l4-4a1 1 0 011.414 0l4 4a1 1 0 01-1.414 1.414L11 7.414V15a1 1 0 11-2 0V7.414L6.707 9.707a1 1 0 01-1.414 0z" clip-rule="evenodd" />
                        </svg>
                        <span class="sr-only">Aumentó en</span>
                        23.1%
                      </div>
                    </dd>
                  </dl>
                </div>
              </div>
            </div>
            <div class="bg-gray-50 px-4 py-4 sm:px-6">
              <div class="text-sm">
                <a href="#" class="font-medium text-indigo-600 hover:text-indigo-500"> Ver detalles<span class="sr-only"> Utilidad neta</span></a>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Gráfico de ingresos vs gastos -->
        <div class="mt-6 bg-white shadow overflow-hidden sm:rounded-lg">
          <div class="px-4 py-5 sm:px-6 border-b border-gray-200">
            <h3 class="text-lg leading-6 font-medium text-gray-900">Ingresos vs Gastos</h3>
            <p class="mt-1 max-w-2xl text-sm text-gray-500">Comparativa mensual</p>
          </div>
          <div class="px-4 py-5 sm:p-6">
            <div class="h-80">
              <canvas id="financialChart"></canvas>
            </div>
          </div>
          <div class="bg-gray-50 px-4 py-4 sm:px-6 text-right">
            <button type="button" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
              <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M3 17a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zm3.293-7.707a1 1 0 011.414 0L9 10.586V3a1 1 0 112 0v7.586l1.293-1.293a1 1 0 111.414 1.414l-3 3a1 1 0 01-1.414 0l-3-3a1 1 0 010-1.414z" clip-rule="evenodd" />
              </svg>
              Exportar a Excel
            </button>
          </div>
        </div>
        
        <!-- Resumen por categoría -->
        <div class="mt-6 bg-white shadow overflow-hidden sm:rounded-lg">
          <div class="px-4 py-5 sm:px-6 border-b border-gray-200">
            <h3 class="text-lg leading-6 font-medium text-gray-900">Ventas por Categoría</h3>
            <p class="mt-1 max-w-2xl text-sm text-gray-500">Distribución de ventas por categoría de producto</p>
          </div>
          <div class="px-4 py-5 sm:p-6">
            <div class="grid grid-cols-1 gap-6 lg:grid-cols-2">
              <div class="h-64">
                <canvas id="categoryChart"></canvas>
              </div>
              <div class="overflow-hidden">
                <table class="min-w-full divide-y divide-gray-200">
                  <thead class="bg-gray-50">
                    <tr>
                      <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Categoría</th>
                      <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Ventas</th>
                      <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">% del Total</th>
                    </tr>
                  </thead>
                  <tbody class="bg-white divide-y divide-gray-200">
                    <tr>
                      <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">Analgésicos</td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{formatCurrency(4250.75)}</td>
                      <td class="px-6 py-4 whitespace-nowrap">
                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                          33.9%
                        </span>
                      </td>
                    </tr>
                    <tr>
                      <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">Antibióticos</td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{formatCurrency(3120.50)}</td>
                      <td class="px-6 py-4 whitespace-nowrap">
                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">
                          24.9%
                        </span>
                      </td>
                    </tr>
                    <tr>
                      <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">Vitaminas</td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{formatCurrency(2150.25)}</td>
                      <td class="px-6 py-4 whitespace-nowrap">
                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">
                          17.1%
                        </span>
                      </td>
                    </tr>
                    <tr>
                      <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">Cuidado Personal</td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{formatCurrency(1875.50)}</td>
                      <td class="px-6 py-4 whitespace-nowrap">
                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-purple-100 text-purple-800">
                          14.9%
                        </span>
                      </td>
                    </tr>
                    <tr>
                      <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">Otros</td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{formatCurrency(1143.75)}</td>
                      <td class="px-6 py-4 whitespace-nowrap">
                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">
                          9.1%
                        </span>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      {/if}
    {/if}
  </div>
</div>

<script>
  // Inicializar gráfico de categorías
  function initCategoryChart() {
    const ctx = document.getElementById('categoryChart');
    if (ctx) {
      new Chart(ctx, {
        type: 'doughnut',
        data: {
          labels: ['Analgésicos', 'Antibióticos', 'Vitaminas', 'Cuidado Personal', 'Otros'],
          datasets: [{
            data: [4250.75, 3120.50, 2150.25, 1875.50, 1143.75],
            backgroundColor: [
              'rgba(79, 70, 229, 0.8)',
              'rgba(99, 102, 241, 0.8)',
              'rgba(167, 139, 250, 0.8)',
              'rgba(217, 70, 239, 0.8)',
              'rgba(236, 72, 153, 0.8)'
            ],
            borderColor: [
              'rgba(79, 70, 229, 1)',
              'rgba(99, 102, 241, 1)',
              'rgba(167, 139, 250, 1)',
              'rgba(217, 70, 239, 1)',
              'rgba(236, 72, 153, 1)'
            ],
            borderWidth: 1
          }]
        },
        options: {
          responsive: true,
          plugins: {
            legend: {
              position: 'right',
            },
            tooltip: {
              callbacks: {
                label: function(context) {
                  const label = context.label || '';
                  const value = context.raw || 0;
                  const total = context.dataset.data.reduce((a, b) => a + b, 0);
                  const percentage = Math.round((value / total) * 100);
                  return `${label}: ${formatCurrency(value)} (${percentage}%)`;
                }
              }
            }
          }
        }
      });
    }
  }
  
  // Función para formatear moneda
  function formatCurrency(amount) {
    return new Intl.NumberFormat('es-PE', { style: 'currency', currency: 'PEN' }).format(amount);
  }
  
  // Inicializar gráficos cuando el componente esté montado
  document.addEventListener('DOMContentLoaded', function() {
    // Pequeño retraso para asegurar que los elementos del DOM estén listos
    setTimeout(initCategoryChart, 100);
  });
  
  // También inicializar cuando Svelte monte el componente
  setTimeout(initCategoryChart, 500);
</script>
