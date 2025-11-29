import createSupabaseClient from './lib/client'
import './style.css'

const client = createSupabaseClient();
const data = await client.from('entities').select();
console.log(data);

// RLSによりエラー
// await client.from('entities').insert({
//   owner_id: '3a14de44-645d-4325-b00d-7e06855d2214',
//   title: 'entity title',
//   url: 'https://example.com/entitiy1',
//   memo: 'entity memo',
// });

// await client.auth.signInWithPassword({
//   email: 'admin@example.com',
//   password: 'password',
// });

// await client.from('entities').insert({
//   owner_id: '3a14de44-645d-4325-b00d-7e06855d2214',
//   title: 'entity title',
//   url: 'https://example.com/entitiy1',
//   memo: 'entity memo',
// });