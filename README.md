# TrailingStop

Este código define una función llamada `getActivePosition` que toma un parámetro `price`. La función primero declara varias variables globales que se utilizan en todo el código. Luego convierte el parámetro `price` en una variable global llamada `globalPrice` utilizando una función llamada `priceConvert`.

La función luego obtiene una lista de posiciones abiertas utilizando la función `positions_get` de la biblioteca MetaTrader 5. Si hay posiciones abiertas, la función recupera la primera posición de la lista y realiza una serie de cálculos basados en el tipo de posición (compra o venta). Estos cálculos incluyen establecer stops de seguimiento, calcular ganancias y cerrar posiciones si se cumplen ciertas condiciones.

Si no hay posiciones abiertas, la función establece todas las variables globales relacionadas con la información de posición en cero. El código también incluye una línea comentada que llama a una función llamada `printInfo(1)` que presumiblemente muestra información sobre el estado actual del algoritmo de trading.
