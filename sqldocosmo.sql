-- 1. Limpa tabelas anteriores para evitar conflitos
DROP TABLE IF EXISTS Pedidos;
DROP TABLE IF EXISTS Clientes;

-- 2. SCRIPT DDL (Estrutura Refatorada)
CREATE TABLE Clientes (
    id_cliente INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_completo VARCHAR(150) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    endereco VARCHAR(255) NOT NULL,
    telefone VARCHAR(20) NOT NULL
);

CREATE TABLE Pedidos (
    id_pedido INTEGER PRIMARY KEY AUTOINCREMENT,
    id_cliente INT NOT NULL,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10, 2) NOT NULL,
    status_pedido VARCHAR(50) DEFAULT 'Pendente',
    
    CONSTRAINT fk_pedido_cliente 
        FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Índices para performance
CREATE INDEX idx_clientes_cpf ON Clientes(cpf);
CREATE INDEX idx_pedidos_cliente ON Pedidos(id_cliente);
CREATE INDEX idx_pedidos_data ON Pedidos(data_pedido);

-- 3. SCRIPT DML (Inserção com CPFs mascarados por segurança)
INSERT INTO Clientes (nome_completo, cpf, endereco, telefone) 
VALUES 
    ('Ana Souza', '111.***.***-44', 'Rua das Flores, 123 - São Paulo, SP', '(11) 98888-7777'),
    ('Carlos Lima', '555.***.***-88', 'Av. Paulista, 1000 - São Paulo, SP', '(11) 97777-6666');

INSERT INTO Pedidos (id_cliente, valor_total, status_pedido) 
VALUES 
    (1, 250.90, 'Concluído'),
    (1, 120.00, 'Enviado'),
    (2, 499.99, 'Processando');

-- 4. Consulta para exibir os valores com o CPF mascarado na tabela
SELECT 
    p.id_pedido,
    c.nome_completo,
    c.cpf,
    p.data_pedido,
    p.valor_total,
    p.status_pedido
FROM Pedidos p
INNER JOIN Clientes c ON p.id_cliente = c.id_cliente
WHERE c.cpf = '111.***.***-44'
ORDER BY p.data_pedido DESC;