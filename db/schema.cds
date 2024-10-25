namespace concessionaria;

using {managed} from '@sap/cds/common';

entity veiculos : managed {
  key id     : Integer;
  key cpf    : String(11);
      nome   : String(100);
      marca  : String(80);
      modelo : String(80);
      preco  : Decimal(9, 2);
      moeda  : Integer enum {
        USD    = 1;
        BRL    = 2;
        Outras = 3;
      }
}

entity usuarios : managed {
  key cpf            : String(11);
      nome           : String(80);
      dataNascimento : Date;
      sexo           : Integer enum {
        Masculino = 1;
        Feminino  = 2;
        Outros    = 3;
      };
      veiculos       : Association to many veiculos
                         on veiculos.cpf = cpf;
}

//Formas de fazer criação de entidade usando o select 
entity report as
  select from usuarios as u
  inner join veiculos as v
    on u.cpf = v.cpf
  {
    key u.cpf,
        u.nome,
        v.marca,
        v.preco,
        case v.moeda
          when
            1
          then
            'Dolar'
          when
            2
          then
            'Real'
          when
            3
          then
            'Outras moedas'
        end as moeda : String(30),
        case u.sexo
          when
            1
          then
            'Masculino'
          when
            2
          then
            'Feminino'
          when
            3
          then
            'Outros'
        end as sexo  : String(30)
  }
