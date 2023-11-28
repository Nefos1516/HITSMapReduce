from random import randint


file = open('input.txt', 'a')

for i in range(1, 50):
    s = ''
    while len(s) < 5:
        for j in range(randint(1, 5)):
            r = randint(1, 50)
            if r != i and str(r) not in s:
                s += f'site{r};'
    file.write(f'site{i}\t1\t1\t{s[:len(s) - 1]}\n')
file.close()