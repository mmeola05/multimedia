# Multimedia - Music Player

A Flutter application for searching and playing music using the iTunes Search API.

## Funcionalidad y Uso

Esta aplicación permite a los usuarios buscar canciones y reproducir una vista previa de las mismas.

### Cómo usar la aplicación:

1.  **Búsqueda:** Utiliza la barra de búsqueda en la parte superior para encontrar canciones por nombre, artista o álbum. Al escribir y presionar Enter, se mostrará una lista de hasta 200 resultados.
2.  **Reproducción:** Toca cualquier canción en la lista para comenzar la reproducción. La aplicación utiliza la URL de vista previa proporcionada por iTunes.
3.  **Controles de Audio:**
    *   **Play/Pause:** El botón central en los controles inferiores permite alternar entre reproducir y pausar la canción actual. También puedes tocar la canción en la lista para pausarla si ya se está reproduciendo.
    *   **Stop:** El botón de parada detiene la reproducción por completo y reinicia la posición.
    *   **Progreso:** Desliza la barra de progreso (Slider) para avanzar o retroceder en la canción.
4.  **Estado Visual:** La canción que se está reproduciendo se resalta en la lista con un icono animado y texto en negrita.

## API Utilizada

La aplicación consume datos de la **iTunes Search API** de Apple.

-   **Base URL:** `https://itunes.apple.com/search`
-   **Endpoint utilizado:** `_baseUrl?term=$query&media=music&limit=200`

Se ha configurado para obtener resultados específicos de música y con un límite amplio de hasta 200 elementos para ofrecer una mejor experiencia de exploración.
