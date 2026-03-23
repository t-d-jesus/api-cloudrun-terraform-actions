import { Pool } from 'pg';

const isProduction = process.env.NODE_ENV === 'production';

const pool = new Pool({
  user: 'api_user',
  host: isProduction 
    ? `/cloudsql/${process.env.PROJECT_ID}:${process.env.REGION}:api-db-instance` 
    : 'localhost',
  database: 'postgres',
  password: process.env.DB_PASSWORD, 
  port: 5432,
});

export const query = (text: string, params?: any[]) => pool.query(text, params);