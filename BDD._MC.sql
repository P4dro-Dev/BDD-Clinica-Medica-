CREATE DATABASE ClinicaMedica;
USE ClinicaMedica;


CREATE TABLE pacientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL
);

CREATE TABLE medicos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    especialidade VARCHAR(50) NOT NULL
);

CREATE TABLE consultas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    medico_id INT NOT NULL,
    data_hora DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Agendada',
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id),
    FOREIGN KEY (medico_id) REFERENCES medicos(id)
);


INSERT INTO pacientes (nome, data_nascimento) VALUES
('João da Silva', '1980-05-15'),
('Maria Oliveira', '1992-08-22'),
('Carlos Souza', '1975-11-30');

INSERT INTO medicos (nome, especialidade) VALUES
('Dra. Ana Costa', 'Cardiologia'),
('Dr. Roberto Santos', 'Ortopedia'),
('Dra. Fernanda Lima', 'Pediatria');

INSERT INTO consultas (paciente_id, medico_id, data_hora, status) VALUES
(1, 1, '2025-06-20 09:00:00', 'Agendada'),
(2, 2, '2025-06-20 10:30:00', 'Agendada');

DELIMITER //
CREATE PROCEDURE AgendarConsulta(
    IN p_paciente_id INT,
    IN p_medico_id INT,
    IN p_data_hora DATETIME
)
BEGIN
    DECLARE consulta_existente INT;
    
    SELECT COUNT(*) INTO consulta_existente
    FROM consultas
    WHERE medico_id = p_medico_id
    AND data_hora = p_data_hora
    AND status = 'Agendada';
    
    IF consulta_existente > 0 THEN
        SELECT 'Erro: O médico já possui uma consulta agendada neste horário.' AS Mensagem;
    ELSE
       
        INSERT INTO consultas (paciente_id, medico_id, data_hora, status)
        VALUES (p_paciente_id, p_medico_id, p_data_hora, 'Agendada');
        
        SELECT 'Consulta agendada com sucesso!' AS Mensagem;
    END IF;
END //
DELIMITER ;

CALL AgendarConsulta(3, 3, '2025-06-20 14:00:00');

CALL AgendarConsulta(1, 1, '2025-06-20 09:00:00');

SELECT 
    c.id AS consulta_id,
    p.nome AS paciente,
    m.nome AS medico,
    m.especialidade,
    c.data_hora,
    c.status
FROM 
    consultas c
    JOIN pacientes p ON c.paciente_id = p.id
    JOIN medicos m ON c.medico_id = m.id
ORDER BY c.data_hora;