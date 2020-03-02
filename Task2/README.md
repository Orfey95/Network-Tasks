## Исследование HTTP протокола 

1) Найти в интернете 8 различных status code HTTP. В запросе и ответе должно содержаться не менее 5 header’s атрибутов. 
```

```
2) Описать назначение всех атрибутов в client request and server response. На примере одного из HTTP request/response описать все header’s атрибуты. 
```

```
3) Найти еще 7 различных status code. Выполнять только после выполнения задания 1. 
```

```
4) Произвести фильтрацию трафика протокола HTTP с помощью tcpdump. Написать два фильтра: 
- фильтровать по методам протокола HTTP.  
- фильтровать по методу и header’s атрибуту в response протокола HTTP 
- фильтровать по методу и header’s атрибуту в request протокола HTTP 
```

```
5) Используя Fiddler выполнить пункт 4. 
```

```
## Исследование API GitLab
Используя утилиту curl написать запросы: 
1) создание нового проекта
```

```
2) удаление проекта 
```

```
3) добавления пользователей с различными ролями 
```

```
4) создание issue и назначение его определенному пользователю 
```

```
5) получение списка пользователей 
- весь
```

```
- с определенными правами
```

```
6) работа с коммитами
- получить список всех комментариев коммита 
```

```
- вставить комментарий в commit в определённую строку от имени пользователя 
```

```
Написать скрипты на bash и Python, параметры должны передаваться из командной строки: 
- создать новый проект с заданным именем в определенной группе; 
- добавить/удалить/изменить роль пользователя на проекте; 
- создать/удалить/изменить набор тегов (bug, DEV_env, QA_env, PROD_env, task) для определенного проекта; 
- создать issue (описание, label) для определенного пользователя, до определенной даты и назначить тег (см,). Если label не существует, то создать. If the milestone is not existing, then it should be created. e)Find all actually marge request and create list of problem line. One record of list must consist from: date_time, name_file, number_line, author, description. Proposed use the Linux command printf 