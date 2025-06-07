import { parentPort, workerData } from 'worker_threads';

function simulateProcessing(tx) {
  // Simula una tarea pesada
  const duration = Math.random() * 3000 + 1000;
  const start = Date.now();
  while (Date.now() - start < duration) {}
  return {
    userId: tx.userId,
    amount: tx.amount,
    category: tx.category,
    type: tx.type,
    message: `Procesado: ${tx.amount} en ${tx.category}`
  };
}

const result = simulateProcessing(workerData);
parentPort.postMessage(result);
