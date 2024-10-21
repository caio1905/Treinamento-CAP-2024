namespace concessionaria;

using {
  Currency,
  managed,
  sap,
  cuid
} from '@sap/cds/common';

entity veiculos : managed {
  key id       : Integer;
      nome     : String(100);
      marca    : String(80);
      modelo   : String(80);
      preco    : Decimal(9, 2);
      moeda    : Currency;
      usuarios : Association to one usuarios;
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
                         on veiculos.usuarios = $self;
}
