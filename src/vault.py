import os
import re
import secrets
import string

from pykeepass import PyKeePass, create_database


def add_entry(
    vault_path,
    master_password,
    title,
    username,
    password,
    website="",
    notes=""
):
    try:
        kp = PyKeePass(vault_path, password=master_password)

        kp.add_entry(
            kp.root_group,
            title,
            username,
            password,
            url=website,
            notes=notes
        )

        kp.save()

        return {
            "success": True,
            "message": "Password saved successfully."
        }

    except Exception as error:
        return {
            "success": False,
            "message": "TouchVault could not save the password.",
            "technical_error": str(error)
        }

def get_entry(vault_path, master_password, entry_uuid):
    try:
        kp = PyKeePass(vault_path, password=master_password)

        entry = None

        for candidate in kp.entries:
            if str(candidate.uuid) == entry_uuid:
                entry = candidate
                break

        if entry is None:
            return {
                "success": False,
                "message": "Password entry could not be found."
            }

        return {
            "success": True,
            "entry": {
                "uuid": str(entry.uuid),
                "title": entry.title or "",
                "username": entry.username or "",
                "password": entry.password or "",
                "website": entry.url or "",
                "notes": entry.notes or ""
            }
        }

    except Exception as error:
        return {
            "success": False,
            "message": "TouchVault could not load the password.",
            "technical_error": str(error)
        }

def update_entry(
    vault_path,
    master_password,
    entry_uuid,
    title,
    username,
    password,
    website="",
    notes=""
):
    try:
        kp = PyKeePass(vault_path, password=master_password)

        entry = None

        for candidate in kp.entries:
            if str(candidate.uuid) == entry_uuid:
                entry = candidate
                break

        if entry is None:
            return {
                "success": False,
                "message": "Password entry could not be found."
            }

        entry.title = title
        entry.username = username
        entry.password = password
        entry.url = website
        entry.notes = notes

        kp.save()

        return {
            "success": True,
            "message": "Password updated successfully."
        }

    except Exception as error:
        return {
            "success": False,
            "message": "TouchVault could not update the password.",
            "technical_error": str(error)
        }

def delete_entry(vault_path, master_password, entry_uuid):
    try:
        kp = PyKeePass(vault_path, password=master_password)

        entry = None

        for candidate in kp.entries:
            if str(candidate.uuid) == entry_uuid:
                entry = candidate
                break

        if entry is None:
            return {
                "success": False,
                "message": "Password entry could not be found."
            }

        kp.delete_entry(entry)
        kp.save()

        return {
            "success": True,
            "message": "Password deleted successfully."
        }

    except Exception as error:
        return {
            "success": False,
            "message": "TouchVault could not delete the password.",
            "technical_error": str(error)
        }

def generate_password(length=20):
    try:
        length = int(length)

        if length < 12:
            length = 12

        lowercase = string.ascii_lowercase
        uppercase = string.ascii_uppercase
        digits = string.digits
        symbols = "!@#$%^&*()-_=+"

        password_chars = [
            secrets.choice(lowercase),
            secrets.choice(uppercase),
            secrets.choice(digits),
            secrets.choice(symbols)
        ]

        all_chars = lowercase + uppercase + digits + symbols

        for _ in range(length - 4):
            password_chars.append(
                secrets.choice(all_chars)
            )

        # Shuffle securely
        for i in range(len(password_chars) - 1, 0, -1):
            j = secrets.randbelow(i + 1)
            password_chars[i], password_chars[j] = (
                password_chars[j],
                password_chars[i]
            )

        return {
            "success": True,
            "password": "".join(password_chars)
        }

    except Exception as error:
        return {
            "success": False,
            "message": "TouchVault could not generate a password.",
            "technical_error": str(error)
        }


def _safe_filename(vault_name):
    """Convert the visible vault name into a safe filename."""
    cleaned = re.sub(r"[^A-Za-z0-9._-]+", "_", vault_name.strip())
    cleaned = cleaned.strip("._")

    if not cleaned:
        cleaned = "TouchVault"

    return cleaned + ".kdbx"


def open_vault(vault_path, master_password):
    try:
        kp = PyKeePass(vault_path, password=master_password)

        return {
            "success": True,
            "name": kp.root_group.name,
            "entries": len(kp.entries)
        }

    except Exception as error:
        return {
            "success": False,
            "message": "TouchVault could not open the vault.",
            "technical_error": str(error)
        }

def list_entries(vault_path, master_password):
    try:
        kp = PyKeePass(vault_path, password=master_password)

        entries = []

        for entry in kp.entries:
            entries.append({
                "uuid": str(entry.uuid),
                "title": entry.title or "",
                "username": entry.username or "",
                "website": entry.url or ""
            })

        return {
            "success": True,
            "entries": entries
        }

    except Exception as error:
        return {
            "success": False,
            "message": "TouchVault could not load the vault entries.",
            "technical_error": str(error)
        }

def list_vaults(output_directory):
    try:
        vaults = []

        if os.path.exists(output_directory):
            for filename in sorted(os.listdir(output_directory)):
                if filename.endswith(".kdbx"):
                    vaults.append({
                        "name": filename.replace(".kdbx", ""),
                        "filename": filename,
                        "path": os.path.join(output_directory, filename)
                    })

        return {
            "success": True,
            "vaults": vaults
        }

    except Exception as error:
        return {
            "success": False,
            "message": "Could not list vaults.",
            "technical_error": str(error)
        }


def create_vault(vault_name, master_password, output_directory):
    """
    Create a KeePass-compatible vault.

    Returns a dictionary that QML can inspect.
    Never return or log the master password.
    """
    if not vault_name or not vault_name.strip():
        return {
            "success": False,
            "message": "Please enter a vault name."
        }

    if not master_password or len(master_password) < 12:
        return {
            "success": False,
            "message": "The master password must contain at least 12 characters."
        }

    try:
        os.makedirs(output_directory, exist_ok=True)

        filename = _safe_filename(vault_name)
        vault_path = os.path.join(output_directory, filename)

        if os.path.exists(vault_path):
            return {
                "success": False,
                "message": "A vault with that name already exists."
            }

        database = create_database(
            filename=vault_path,
            password=master_password
        )

        database.save()

        return {
            "success": True,
            "message": "Vault created successfully.",
            "path": vault_path,
            "filename": filename
        }


    except Exception as error:
        return {
            "success": False,
            "message": "TouchVault could not create the vault.",
            "technical_error": str(error)
        }