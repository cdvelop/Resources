### 📊 Cálculo de Nota (escala 1.0 a 7.0)

La nota final se calcula con la siguiente fórmula:

```latext
\text{Nota} = 1 + \left( \frac{\text{Puntos Obtenidos}}{\text{Puntaje Total}} \right) \cdot 6
```
```
Nota = 1 + (Puntos_Obtenidos / Puntaje_Total) * 6
```

#### 🧩 Interpretación

* **Puntos Obtenidos / Puntaje Total**
  Representa el porcentaje de logro del alumno (valor entre 0 y 1).

* **Multiplicación por 6**
  La escala de notas va de 1.0 a 7.0 → rango total = 6 puntos.

* **Suma de 1**
  Ajusta el resultado a la escala final (mínimo 1.0).

---

#### ✅ Ejemplo

Si un alumno obtiene **40 puntos de 50**:

1. ( 40 / 50 = 0.8 )
2. ( 0.8 \times 6 = 4.8 )
3. ( 1 + 4.8 = 5.8 )

👉 **Nota final: 5.8**

---

### 📈 Fórmula en Excel

Si tienes:

* **A1** = Puntos obtenidos
* **B1** = Puntaje total

Usa:

```excel
=1 + (A1 / B1) * 6
```

---

### 💡 Opcional (redondeo)

Para redondear a **1 decimal**:

```excel
=REDONDEAR(1 + (A1 / B1) * 6; 1)
```

