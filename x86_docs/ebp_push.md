## EBP Push

---

At the beginning of almost all functions we have those instructions.

```
    0x08048ec0 <+0>:	push   %ebp
    0x08048ec1 <+1>:	mov    %esp,%ebp
    [...]
    0x08048ec6 <+6>:	sub    $0x20,%esp
```

Those instructions are used to allocate memory for the function then destroy it at the end. Here is an example of what those instructions do.


```
|----------------| <--ebp
| Data from prev |
|----------------|
| Return ptr     |
|----------------| <--esp

<0> :

|----------------| <--ebp
| Data from prev |
|----------------|
| Return ptr     |
|----------------|
| Prev ebp ptr   |
|----------------| <--esp

<1> :

|----------------|
| Data from prev |
|----------------|
| Return ptr     |
|----------------|
| Prev ebp ptr   |
|----------------| <--esp \ ebp

<6> :

|----------------|
| Data from prev |
|----------------|
| Return ptr     |
|----------------|
| Prev ebp ptr   |
|----------------|
| Extra space    | <--ebp
|----------------|
|                |
| Space free     |
|                |
|                |
|----------------| <--esp

```


---
*Source :*

*https://www.youtube.com/watch?v=nbZJOT1gKX4&list=PLRDSgBhFAV_MAkTgPSUAcRXeSZLkYjW3p&index=2&t=1186s*