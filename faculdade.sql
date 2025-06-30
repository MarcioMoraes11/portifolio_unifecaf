USE faculdade;

-- Tabela de Endereços
CREATE TABLE IF NOT EXISTS endereco (
    id_endereco INT AUTO_INCREMENT PRIMARY KEY,
    cep VARCHAR(9) NOT NULL,
    logradouro VARCHAR(100) NOT NULL,
    numero VARCHAR(10),
    complemento VARCHAR(50),
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(2) NOT NULL
) ENGINE=InnoDB;

-- Tabela de Alunos
CREATE TABLE IF NOT EXISTS aluno (
    id_aluno INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    data_nascimento DATE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(15),
    id_endereco INT,
    data_ingresso DATE NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_endereco) REFERENCES endereco(id_endereco) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Tabela de Cursos
CREATE TABLE IF NOT EXISTS curso (
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    codigo VARCHAR(10) UNIQUE NOT NULL,
    duracao_semestres INT NOT NULL,
    carga_horaria_total INT NOT NULL,
    modalidade ENUM('Presencial', 'EAD') NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;

-- Tabela de Professores
CREATE TABLE IF NOT EXISTS professor (
    id_professor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    titulacao ENUM('Graduação', 'Especialização', 'Mestrado', 'Doutorado') NOT NULL,
    email_institucional VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(15),
    id_endereco INT,
    data_contratacao DATE NOT NULL,
    regime_trabalho ENUM('20h', '40h', 'Horista') NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_endereco) REFERENCES endereco(id_endereco) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Tabela de Disciplinas
CREATE TABLE IF NOT EXISTS disciplina (
    id_disciplina INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(10) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    carga_horaria INT NOT NULL,
    ementa TEXT,
    creditos INT NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;

-- Tabela de Relação Curso-Disciplina
CREATE TABLE IF NOT EXISTS curso_disciplina (
    id_curso_disciplina INT AUTO_INCREMENT PRIMARY KEY,
    id_curso INT NOT NULL,
    id_disciplina INT NOT NULL,
    semestre_ofertado INT NOT NULL,
    obrigatoria BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_curso) REFERENCES curso(id_curso) ON DELETE CASCADE,
    FOREIGN KEY (id_disciplina) REFERENCES disciplina(id_disciplina) ON DELETE CASCADE,
    UNIQUE KEY (id_curso, id_disciplina)
) ENGINE=InnoDB;

-- Tabela de Salas
CREATE TABLE IF NOT EXISTS sala (
    id_sala INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(10) UNIQUE NOT NULL,
    capacidade INT NOT NULL,
    tipo ENUM('Sala Comum', 'Laboratório', 'Auditório') NOT NULL,
    descricao TEXT
) ENGINE=InnoDB;

-- Tabela de Turmas
CREATE TABLE IF NOT EXISTS turma (
    id_turma INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(10) NOT NULL,
    id_disciplina INT NOT NULL,
    id_professor INT NOT NULL,
    id_sala INT,
    periodo_letivo VARCHAR(10) NOT NULL, -- Ex: "2023.2"
    horario VARCHAR(100) NOT NULL, -- Ex: "Segunda 14:00-16:00"
    vagas INT NOT NULL,
    vagas_ocupadas INT DEFAULT 0,
    FOREIGN KEY (id_disciplina) REFERENCES disciplina(id_disciplina),
    FOREIGN KEY (id_professor) REFERENCES professor(id_professor),
    FOREIGN KEY (id_sala) REFERENCES sala(id_sala) ON DELETE SET NULL,
    UNIQUE KEY (codigo, periodo_letivo)
) ENGINE=InnoDB;

-- Tabela de Matrículas
CREATE TABLE IF NOT EXISTS matricula (
    id_matricula INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT NOT NULL,
    id_turma INT NOT NULL,
    data_matricula DATE NOT NULL,
    situacao ENUM('Cursando', 'Aprovado', 'Reprovado', 'Trancado') DEFAULT 'Cursando',
    FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno) ON DELETE CASCADE,
    FOREIGN KEY (id_turma) REFERENCES turma(id_turma) ON DELETE CASCADE,
    UNIQUE KEY (id_aluno, id_turma)
) ENGINE=InnoDB;

-- Tabela de Avaliações
CREATE TABLE IF NOT EXISTS avaliacao (
    id_avaliacao INT AUTO_INCREMENT PRIMARY KEY,
    id_turma INT NOT NULL,
    tipo VARCHAR(50) NOT NULL, -- Ex: "Prova 1", "Trabalho Final"
    peso DECIMAL(3,2) NOT NULL, -- Ex: 0.3 para 30%
    data_avaliacao DATE,
    FOREIGN KEY (id_turma) REFERENCES turma(id_turma) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Tabela de Notas
CREATE TABLE IF NOT EXISTS nota (
    id_nota INT AUTO_INCREMENT PRIMARY KEY,
    id_matricula INT NOT NULL,
    id_avaliacao INT NOT NULL,
    valor DECIMAL(4,2) NOT NULL, -- Ex: 8.5
    FOREIGN KEY (id_matricula) REFERENCES matricula(id_matricula) ON DELETE CASCADE,
    FOREIGN KEY (id_avaliacao) REFERENCES avaliacao(id_avaliacao) ON DELETE CASCADE,
    UNIQUE KEY (id_matricula, id_avaliacao)
) ENGINE=InnoDB;

-- Tabela de Frequência
CREATE TABLE IF NOT EXISTS frequencia (
    id_frequencia INT AUTO_INCREMENT PRIMARY KEY,
    id_matricula INT NOT NULL,
    data_aula DATE NOT NULL,
    presente BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_matricula) REFERENCES matricula(id_matricula) ON DELETE CASCADE,
    UNIQUE KEY (id_matricula, data_aula)
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;
