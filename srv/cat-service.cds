using concessionaria as con from '../db/schema';

service Database {
    entity Usuarios as projection on con.usuarios;
    entity Veiculos as projection on con.veiculos;
}
