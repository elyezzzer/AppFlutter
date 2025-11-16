# AppFlutter

Aplicativo Flutter para gerenciar ferramentas e empréstimos de forma simples e intuitiva.

## Visão Geral

Este projeto é uma aplicação móvel e multiplataforma construída com Flutter (Dart). Ele permite cadastrar ferramentas, listar as disponíveis, controlar empréstimos e visualizar as ferramentas emprestadas.

# Setup do projeto

## Clonar repositório

```bash
git clone https://github.com/elyezzzer/AppFlutter.git
```

## Entrar na pasta do projeto
```bash
cd /appflutter
```

## Instalar dependências

```bash
flutter pub get
```

## Configurar firebase (WEB)

```bash
static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'xxxxx',
    appId: 'xxxxx',
    messagingSenderId: '731362222841',
    projectId: 'emprestimodeferramentas',
    authDomain: 'emprestimodeferramentas.firebaseapp.com',
    storageBucket: 'emprestimodeferramentas.firebasestorage.app',
    measurementId: 'G-Y1KZKPCP1S',
  );
```

## Rodar o app
```bash
flutter run -d chrome
```


## Em caso de algum erro
```bash
flutter clean
flutter pub get
```
