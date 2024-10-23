using concessionaria as con from '../db/schema';

@path:'master'
service Database {
    entity Usuarios as projection on con.usuarios;
    entity Veiculos as projection on con.veiculos;

    type usersReport : many {
        NAME : String(80);
        CPF : String(11);
        CREATED : DateTime;
        MODIFIED : DateTime;
    }

    function usersWithCars() returns usersReport
}
