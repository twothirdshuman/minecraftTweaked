def f(x, y):
    if y == 1:
        return x
    return 2 * f(x, y - 1) + x

# Intervall för x och y
x_values = range(1, 9)
y_values = range(1, 9)

# Skapa Markdown-tabell
header = "| x \\ y | " + " | ".join(str(y) for y in y_values) + " |"
separator = "|--------|" + "|".join(["-------"] * len(y_values)) + "|"

rows = []
for x in x_values:
    row = f"| {x}      | " + " | ".join(str(f(x, y)) for y in y_values) + " |"
    rows.append(row)

# Skriv ut tabellen
print("\n".join([header, separator] + rows))
