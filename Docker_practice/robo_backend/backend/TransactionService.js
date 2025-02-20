const dbcreds = require('./DbConfig');
const mysql = require('mysql2'); // Change to mysql2

const con = mysql.createConnection({
    host: process.env.DB_HOST || dbcreds.DB_HOST,
    user: process.env.DB_USER || dbcreds.DB_USER,
    password: process.env.DB_PWD || dbcreds.DB_PWD,
    database: process.env.DB_DATABASE || dbcreds.DB_DATABASE
});

function addTransaction(amount, desc) {
    if (!amount || isNaN(Number(amount))) {
        console.error("Invalid or empty amount provided.");
        return { error: "Invalid or empty amount provided." };
    }
    var sql = `INSERT INTO \`transactions\` (\`amount\`, \`description\`) VALUES ('${amount}', '${desc}')`;
    con.query(sql, function(err, result) {
        if (err) {
            console.error("Error adding transaction:", err.message);
            return { error: err.message };
        }
        console.log("Transaction added successfully.");
    });
    return 200; // Consider changing to proper async handling or callback pattern
}


function getAllTransactions(callback){
    var mysql = "SELECT * FROM transactions";
    con.query(mysql, function(err,result){
        if (err) throw err;
        //console.log("Getting all transactions...");
        return(callback(result));
    });
}

function findTransactionById(id,callback){
    var mysql = `SELECT * FROM transactions WHERE id = ${id}`;
    con.query(mysql, function(err,result){
        if (err) throw err;
        console.log(`retrieving transactions with id ${id}`);
        return(callback(result));
    }) 
}

function deleteAllTransactions(callback){
    var mysql = "DELETE FROM transactions";
    con.query(mysql, function(err,result){
        if (err) throw err;
        //console.log("Deleting all transactions...");
        return(callback(result));
    }) 
}

function deleteTransactionById(id, callback){
    var mysql = `DELETE FROM transactions WHERE id = ${id}`;
    con.query(mysql, function(err,result){
        if (err) throw err;
        console.log(`Deleting transactions with id ${id}`);
        return(callback(result));
    }) 
}

module.exports = {
    addTransaction,
    getAllTransactions,
    findTransactionById,
    deleteAllTransactions,
    deleteTransactionById
};

