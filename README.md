# pomodoro

## 🚀 Sobre o Projeto

O **Tempus** é um aplicativo Flutter que auxilia na gestão do tempo utilizando a técnica Pomodoro ⏲️. Ele ajuda a aumentar a produtividade, alternando períodos de foco e pausas.

<p align="center">
    <img src="https://i.imgur.com/T4yDy7y.png" alt="Tempus logo" width="140" />
</p>

<p align="center">
    <img src="https://i.imgur.com/OmqvUcE.jpeg" alt="Screenshot 1" width="260" style="margin:6px; border-radius:12px;" />
    <img src="https://i.imgur.com/GnSYsi1.jpeg" alt="Screenshot 2" width="260" style="margin:6px; border-radius:12px;" />
    <img src="https://i.imgur.com/zTDhhNS.jpeg" alt="Screenshot 3" width="260" style="margin:6px; border-radius:12px;" />
</p>

<p align="center">
    <img src="https://i.imgur.com/QMSgOig.jpeg" alt="Screenshot 4" width="260" style="margin:6px; border-radius:12px;" />
    <img src="https://i.imgur.com/2i2xxKs.jpeg" alt="Screenshot 5" width="260" style="margin:6px; border-radius:12px;" />
</p>

## 🛠️ Funcionalidades

- Iniciar, pausar e resetar o timer Pomodoro 🕒
- Configuração de tempo de foco e descanso ⚙️
- Histórico de sessões concluídas 📊
- Notificações sonoras ao final de cada ciclo 🔔

## ✨ Novidades (Tempus)

- **Tema roxo com gradiente + Dark Mode:** visual renovado com suporte a tema escuro automático.
- **Novas telas:** `Home`, `Stats`, `Settings`, `Profile`, `About` com navegação moderna.
- **Persistência local:** preferências e histórico salvos via serviço de armazenamento.
- **Áudio e notificações:** serviço dedicado para tocar sons ao fim dos ciclos.
- **Configurações avançadas:** personalização de durações, som e comportamento do timer.

## 🏗 Arquitetura & principais arquivos

- **Pasta modular:** o código está organizado em `lib/theme`, `lib/screens`, `lib/widgets`, `lib/providers`, `lib/services`, `lib/models`.
- **Gerenciamento de estado:** `provider` para `TimerProvider` e `SettingsProvider` (veja `lib/providers`).
- **Serviços principais:** `StorageService` (persistência) e `AudioService` (sons) em `lib/services`.
- **Tema centralizado:** `lib/theme/tempus_theme.dart` e `lib/theme/tempus_colors.dart`.
- **Tela About melhorada:** `lib/screens/about/about_screen.dart` — agora abre links com tratamento de erro e feedback.

## 🧭 Build & Observações

- Para rodar localmente:

```bash
flutter pub get
flutter run
```

- Para gerar APK via CLI:

```bash
flutter build apk
```

- Observação Android: builds Android dependem do SDK/NDK e da versão do Android Gradle Plugin; se encontrar erros de NDK ou AGP, verifique as variáveis de ambiente (`ANDROID_SDK_ROOT` / `ANDROID_HOME`) e o arquivo `android/settings.gradle.kts`.


## 📱 Tecnologias Utilizadas

- [Flutter](https://flutter.dev/) 💙
- [Dart](https://dart.dev/) 🦄

## 📦 Instalação

1. Clone o repositório:
    ```bash
    git clone https://github.com/DiogenesYazan/pomodoro.git
    ```
2. Acesse a pasta do projeto:
    ```bash
    cd pomodoro
    ```
3. Instale as dependências:
    ```bash
    flutter pub get
    ```
4. Execute o aplicativo:
    ```bash
    flutter run
    ```

## 🤝 Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests.

## 👨‍💻 Autor

Feito com 💚 por [Diogenes Yazan](https://github.com/DiogenesYazan/pomodoro.git)

