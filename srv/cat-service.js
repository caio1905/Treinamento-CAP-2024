const cds = require('@sap/cds')

module.exports = cds.service.impl(async function () {

    const srv = await cds.connect.to('db')

    const validarCPF = async cpf => {
        cpf = cpf.replace(/[^\d]+/g, ''); // Remove caracteres não numéricos

        if (cpf.length !== 11 || /^(\d)\1{10}$/.test(cpf)) {
            return false; // Verifica se o CPF tem 11 dígitos e não é uma sequência de números iguais
        }

        let soma = 0;
        let resto;

        // Validação do primeiro dígito verificador
        for (let i = 1; i <= 9; i++) {
            soma += parseInt(cpf.substring(i - 1, i)) * (11 - i);
        }

        resto = (soma * 10) % 11;
        if (resto === 10 || resto === 11) {
            resto = 0;
        }
        if (resto !== parseInt(cpf.substring(9, 10))) {
            return false;
        }

        soma = 0;

        // Validação do segundo dígito verificador
        for (let i = 1; i <= 10; i++) {
            soma += parseInt(cpf.substring(i - 1, i)) * (12 - i);
        }

        resto = (soma * 10) % 11;
        if (resto === 10 || resto === 11) {
            resto = 0;
        }
        if (resto !== parseInt(cpf.substring(10, 11))) {
            return false;
        }

        return true;
    }

    this.before('CREATE', 'Usuarios', async req => {
        const data = req.data
        console.log(data)
        const iTest = await validarCPF(data.cpf)
        console.log(iTest)
        if (iTest === false) {
            req.error({
                error: 'CPF Inválido',
                value: `${data.cpf}`,
                code: '400'
            })
        }
    })

    this.on('usersWithCars', async req => {
        try {
            const dataUsers = await srv.read('DATABASE_USUARIOS')
            const dataVehicle = await srv.read('DATABASE_VEICULOS')
            let aReturns = []
            const results = dataUsers.filter(user => {
                return dataVehicle.some(vehicle => user.CPF === vehicle.CPF)
            })
            if (results) {
                results.forEach(data => {
                    var oResult = {}
                    oResult.NAME = data.NOME
                    oResult.CPF = data.CPF
                    oResult.CREATED = data.CREATEDAT
                    oResult.MODIFIED = data.MODIFIEDAT
                    aReturns.push(oResult)
                    oResult = {}
                })
                req.reply(aReturns)
            }
        } catch (e) {
            console.log(e)
            req.error(e)
        }
    })
})