import random

DELTA = 0x9e3779b9


def tea_encrypt(ptxt, key):
    """ Esegui la cifratura TEA su un blocco di testo in chiaro usando una chiave a 128 bit """
    v0, v1 = (ptxt >> 32) & 0xFFFFFFFF, ptxt & 0xFFFFFFFF
    key_parts = [(key >> shift) & 0xFFFFFFFF for shift in (96, 64, 32, 0)]
    sum = 0
    for _ in range(32):
        sum = (sum + DELTA) & 0xFFFFFFFF
        v0 = (v0 + (((v1 << 4) + key_parts[0]) ^ (v1 + sum) ^ ((v1 >> 5) + key_parts[1]))) & 0xFFFFFFFF
        v1 = (v1 + (((v0 << 4) + key_parts[2]) ^ (v0 + sum) ^ ((v0 >> 5) + key_parts[3]))) & 0xFFFFFFFF
    ctxt = (v0 << 32) | v1
    return ctxt


def generate_random_plaintexts(num_tests):
    f""" Genera un file contenente {num_tests} plaintext casuali """
    with open("pt.txt", "w") as f:
        for _ in range(num_tests):
            ptxt = random.getrandbits(64)
            f.write(f"{ptxt:016X}\n")


def generate_random_keys(num_tests):
    f""" Genera un file contenente {num_tests} chiavi casuali """
    with open("keys.txt", "w") as f:
        for _ in range(num_tests):
            key = random.getrandbits(128)
            f.write(f"{key:032X}\n")


def generate_expected_ciphertexts(num_tests):
    f""" Genera un file contenente i {num_tests} ciphertext attesi per ogni coppia di plaintext e chiave """
    with open("pt.txt", "r") as f_ptxt, open("keys.txt", "r") as f_key, open("ct.txt", "w") as f_ctxt:
        for ptxt_line, key_line in zip(f_ptxt, f_key):
            ptxt = int(ptxt_line.strip(), 16)
            key = int(key_line.strip(), 16)
            ctxt = tea_encrypt(ptxt, key)
            f_ctxt.write(f"{ctxt:016X}\n")


def main():
    num_tests = 500  # Numero di test da generare

    generate_random_plaintexts(num_tests)
    generate_random_keys(num_tests)
    generate_expected_ciphertexts(num_tests)
    print(f"Generati {num_tests} test di plaintext, chiavi e ciphertext attesi.")
    print("#" * 80)

if __name__ == "__main__":
    main()
