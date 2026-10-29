# ring0-asm

Ambiente de desenvolvimento e testes para Bootloaders x86 (Bare-Metal Assembly) em Modo Real (16-bit). O projeto compila o código em Assembly via **NASM**, gera uma imagem de disquete estruturada em setores e executa a simulação via **QEMU** empacotado em um container **Docker** acessível via navegador Web (noVNC) ou cliente VNC nativo.

---

## 🚀 Quick Start

Com as dependências instaladas, clone o repositório e inicie a simulação com um único comando:

```bash
make simu

```

Após a inicialização do container, acesse **`http://localhost:6080`** no seu navegador para visualizar a tela do QEMU rodando o seu bootloader.

---

## 📋 Pré-requisitos

Certifique-se de ter os seguintes utilitários instalados no seu sistema hospedeiro:

* [GNU Make](https://www.gnu.org/software/make/)
* [NASM (Netwide Assembler)](https://www.nasm.us/)
* [Docker](https://www.docker.com/)

---

## 🛠️ Comandos do Makefile

O projeto conta com automação via `Makefile` com compilação incremental, checagem de sintaxe, testes automatizados de MBR e controle de cache do Docker.

| Comando | Descrição |
| --- | --- |
| `make` / `make all` | Compila o binário em Assembly, cria o disquete e constrói a imagem Docker (se necessário). |
| `make build` | Compila os arquivos `.asm` e gera o arquivo de imagem de disco (`./bin/diskette`). |
| `make simu` | Compila as dependências e inicia o container Docker com QEMU, VNC e noVNC. |
| `make lint` | Checa a sintaxe do Assembly e avisa sobre labels órfãs e *overflows* sem gerar binários. |
| `make test` | **Testes de MBR:** Valida se o setor 1 tem exatamente 512 bytes e se possui a assinatura `0xAA55`. |
| `make rebuild` | Limpa a pasta `./bin` e recompila todos os artefatos do zero. |
| `make clean` | Remove o diretório `./bin` e seus artefatos gerados. |

---

## 📁 Estrutura do Projeto

```text
ring0-asm/
├── src/
│   ├── boot.asm           # Código-fonte principal do Bootloader (Setor 1 / MBR)
│   ├── sector2.txt        # Conteúdo/Código do Setor 2 do disco
│   ├── read_sector.asm    # Rotina de leitura de setores via BIOS (int 0x13)
│   ├── read_disk.asm      # Rotina de seleção de unidade de disco
│   └── vga_print.asm      # Rotina de impressão de texto em modo teletipo (int 0x10)
├── bin/                   # Artefatos gerados pelo build (ignorado no Git)
│   ├── boot               # Binário do setor de boot (512 bytes)
│   └── diskette           # Imagem bruta de disquete 1.44MB com Setor 1 + Setor 2
├── Dockerfile             # Imagem Debian Slim com QEMU x86_64, noVNC e websockify
├── entrypoint.sh          # Script de inicialização da ponte WebSocket e do QEMU
└── Makefile               # Automação de compilação, testes e execução

```

---

## 🖥️ Acesso à Interface Gráfica

Assim que o comando `make simu` subir o container, a tela gráfica do QEMU pode ser acessada de duas formas:

1. **Navegador Web (noVNC):** `http://localhost:6080` *(Porta Web/WebSocket)*
2. **Cliente VNC Nativo:** `localhost:5900` *(Porta VNC Padrão TCP)*

---

## 💾 Layout do Disco

O `Makefile` monta automaticamente a imagem do disquete (`./bin/diskette`) com a seguinte estrutura de setores:

## 💾 Layout do Disco e Mapeamento de Memória

| Elemento | Posição no Disco | Endereço na RAM (ES:BX) | Descrição |
| :--- | :--- | :--- | :--- |
| **Setor 1 (MBR)** | `0x0000` (Byte 0) | `0x0000:0x7C00` | Código do `boot.asm` (512 bytes) carregado automaticamente pela BIOS. |
| **Setor 2** | `0x0200` (Byte 512) | `0x0000:0x0500` | Conteúdo do `sector2.txt` lido do disco via `int 0x13` e copiado para a RAM.  |
