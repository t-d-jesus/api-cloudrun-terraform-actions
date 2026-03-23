import express from 'express';
import { query } from './database';

const app = express();
const port = process.env.PORT || 8080;

app.get('/', async (req, res) => {
  try {
    const result = await query('SELECT NOW()');
    res.json({ 
      message: "API Online e Conectada ao Banco!", 
      db_time: result.rows[0].now 
    });
  } catch (err: any) {
    res.status(500).json({ 
      error: "Erro ao conectar no banco", 
      details: err.message 
    });
  }
});

app.listen(port, () => {
  console.log(`Servidor rodando na porta ${port}`);
});