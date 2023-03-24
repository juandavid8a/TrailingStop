# TrailingStop

Este código define una función llamada `getActivePosition` que toma un parámetro `price`. La función primero declara varias variables globales que se utilizan en todo el código. Luego convierte el parámetro `price` en una variable global llamada `globalPrice` utilizando una función llamada `priceConvert`.

La función luego obtiene una lista de posiciones abiertas utilizando la función `positions_get` de la biblioteca MetaTrader 5. Si hay posiciones abiertas, la función recupera la primera posición de la lista y realiza una serie de cálculos basados en el tipo de posición (compra o venta). Estos cálculos incluyen establecer stops de seguimiento, calcular ganancias y cerrar posiciones si se cumplen ciertas condiciones.

Si no hay posiciones abiertas, la función establece todas las variables globales relacionadas con la información de posición en cero. El código también incluye una línea comentada que llama a una función llamada `printInfo(1)` que presumiblemente muestra información sobre el estado actual del algoritmo de trading.

```bash
globalSpreadBuy = 3
globalSpreadSell = 3
globalTrailing = 3
globalTrailingStop = 2
globalSymbol = "EURUSD"
globalVolume = 0.10
```
globalSpreadBuy = Spread de compra

globalSpreadSell = Spread de venta
Si el broken no tiene diferencia de Spread entre compras y ventas se configura el mismo spread en las dos variables

globalTrailing = valor de la cantitad de Ticks despues de los cuales se va a establecer automaticamente el StopLost

globalTrailingStop = valos de cantidad de Ticks se va a establecer el StopLost (la diferencia entre globalTrailing y globalTrailingStop es la cantidad de Ticks que se van a dejar de margen para que el mercado oscile antes de tocar el StopLost)

globalSymbol = Nomeda en que se va a trabajar (Necesario para abrir o cerrar automaticamente las posiciones)

globalVolume = Lotaje de las posiciones (Necesario para abrir o cerrar automaticamente las posiciones)
