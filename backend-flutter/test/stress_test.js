import axios from 'axios';

const TOTAL_REQUESTS = 10;

const sendTransaction = async (index) => {
  try {
    const response = await axios.post('http://localhost:4000/api/transactions', {
      userId: `user_${index}`,
      amount: Math.floor(Math.random() * 1000),
      type: index % 2 === 0 ? 'income' : 'expense',
      category: index % 2 === 0 ? 'Salary' : 'Food'
    });
    console.log(`✅ Tarea ${index} completada:`, response.data);
  } catch (error) {
    console.error(`❌ Error en tarea ${index}:`, error.message);
  }
};

const runStressTest = async () => {
  console.log(`🚀 Lanzando ${TOTAL_REQUESTS} tareas en paralelo...\n`);
  const promises = [];
  for (let i = 1; i <= TOTAL_REQUESTS; i++) {
    promises.push(sendTransaction(i));
  }
  await Promise.all(promises);
  console.log(`\n✅ Prueba de carga completada`);
};

runStressTest();
