## Memory alignment
---
In almost all disassembled main functions we see this line at the beginning.

```
0x08048ec3 <+3>:	and    $0xfffffff0,%esp
```

This line has two purposes :

1. It's align the memory to optimize performance of the memory.
2. This extra space (16bytes) is required to execute SIMD instructions.

---

*Source :*

*http://r0x0r.vishalmishra.in/2013/09/why-and-0xfffffff0esp.html*

*https://reverseengineering.stackexchange.com/questions/15173/what-is-the-purpose-of-these-instructions-before-the-main-preamble*
