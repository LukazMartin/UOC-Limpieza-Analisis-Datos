# UOC-Limpieza-Analisis-Datos

Práctica 2: ¿Cómo realizar la limpieza y análisis de datos?

Asignatura: Tipología y ciclo de vida de los datos

Autores: **Lukaz Martin Doehne** & **Pablo Vadillo Berganza**

Profesora: Laia Subirats Maté


## Descripción

El objetivo de esta práctica es limpiar, analizar, visualizar y sacar conclusiones de un dataset. El dataset seleccionado fue propuesto para esta práctica.

Link al dataset: https://www.kaggle.com/datasets/rashikrahmanpritom/heart-attack-analysis-prediction-dataset

El csv del dataset se encuentra en **data/heart.csv**

El csv procesado se encuentra en **data/heart_processed.csv**

El código con el que se creó la memoria se encuentra en **code/code_&_memory.Rmd**

Solo el código R está en **code/code.R**

## Dataset

El dataset consta de 303 registros y 14 variables que representan cada paciente. El formato es el siguiente:

 · **Age**: Edad de los pacientes en años. Toma valores entre 29 y 77. La media es 54,37.
  
  · **Sex**: Sexo de los pacientes. (1 = hombre; 0 = mujer).
  
  · **Cp**: Dolor de pecho. (1 = angina típica; 2 = angina atípica; 3 = dolor no anginal; 4 = asintomático).
  
  · **Trtbps**: Presión arterial en reposo. Se trata del valor tomado en el ingreso al hospital, en mm Hg. Toma valores entre 94 y 200, siendo la media de 131,6.
  
  · **Chol**: Colesterol sérico. Medido en mg/dl. Toma valores entre 126 y 564, con una media de 246,3.
  
  · **Fbs**: Nivel de azúcar en sangre en ayunas. (1 = > 120 mg/dl; 0 = <= 120 mg/dl).
  
  · **Restecg**: Resultados del electrocardiograma en reposo. (0 = normal; 1 = onda ST-T anómala; 2 = hipertrofia ventricular izquierda).
  
  · **Thalachh**: Máximo pulso cardíaco obtenido. Toma valores entre 71 y 202. La media es 149,6.
  
  · **Exng**: Angina inducida del ejercicio. (1 = sí; 0 = no).
  
  · **Oldpeak**: Depresión del segmento ST inducida por ejercicio relativo al descanso. Toma valores entre 0 y 6,2, con una media de 1,04.
  
  · **Slp**: Pendiente del segmento ST del pico del ejercicio. (1 = ascendente; 2 = plano; 3 = descendente).
  
  · **Caa**: Número de los principales vasos sanguíneos coloreados por la fluoroscopia. Toma valores entre 0 y 4, con una media de 0,73.
  
  · **Thall**: Talasemia. Menor nivel de hemoglobina. (1 = defecto fijo; 2 = normal; 3 = defecto reversible). El defecto fijo hace referencia a un defecto que ocurre tanto en reposo como durante el esfuerzo. El defecto reversible, por el contrario, hace referencia a un defecto que ocurre durante el esfuerzo que no existía durante el reposo.

  · **Output**: La variable a predecir. Diagnóstico de fallo cardíaco (0 = Estrechamiento de vasos sanguíneos < 50%; 1 = Estrechamiento de vasos sanguíneos > 50%).
