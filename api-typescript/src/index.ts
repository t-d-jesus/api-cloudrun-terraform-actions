import express from 'express';
import { Pool } from 'pg';

const app = express();
const port = process.env.PORT || 8080;

const pool = new Pool({
  host: process.env.DB_HOST,     
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

app.get('/health', (req, res) => {
  res.status(200).send('OK');
});

app.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT NOW()');
    res.json({ 
      message: "API conectada ao Cloud SQL!", 
      db_time: result.rows[0].now 
    });
  } catch (err) {
    res.status(500).json({ error: "Erro ao conectar no banco", details: err });
  }
});

app.listen(port, () => {
  console.log(`Servidor rodando na porta ${port}`);
});