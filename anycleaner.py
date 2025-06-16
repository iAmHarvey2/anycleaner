# anycleaner.py - Versión 0.33

import os
import shutil
import logging

# Configurar logging
log_file = os.path.join(os.getenv("APPDATA"), "AnyDesk", "anycleaner.log")
logging.basicConfig(filename=log_file, level=logging.INFO, format='%(asctime)s - %(message)s')

def limpiar_carpetas(base_path, carpetas):
    for carpeta in carpetas:
        full_path = os.path.join(base_path, carpeta)
        if os.path.exists(full_path):
            try:
                for item in os.listdir(full_path):
                    item_path = os.path.join(full_path, item)
                    if os.path.isdir(item_path):
                        shutil.rmtree(item_path, ignore_errors=True)
                    else:
                        os.remove(item_path)
                logging.info(f"Contenido de '{carpeta}' eliminado.")
            except Exception as e:
                logging.error(f"Error al limpiar '{carpeta}': {e}")
        else:
            logging.info(f"La carpeta '{carpeta}' no existe.")

def eliminar_archivo(ruta_archivo):
    if os.path.exists(ruta_archivo):
        try:
            os.remove(ruta_archivo)
            logging.info(f"Archivo '{os.path.basename(ruta_archivo)}' eliminado.")
        except Exception as e:
            logging.error(f"Error al eliminar '{ruta_archivo}': {e}")
    else:
        logging.info(f"Archivo '{os.path.basename(ruta_archivo)}' no encontrado.")

def renombrar_archivo(origen, destino):
    if os.path.exists(origen):
        try:
            if os.path.exists(destino):
                os.remove(destino)
            os.rename(origen, destino)
            logging.info(f"'{os.path.basename(origen)}' renombrado a '{os.path.basename(destino)}'.")
        except Exception as e:
            logging.error(f"Error al renombrar '{origen}': {e}")
    else:
        logging.info(f"'{os.path.basename(origen)}' no encontrado.")

def vaciar_txt(ruta_txt):
    if os.path.exists(ruta_txt):
        try:
            with open(ruta_txt, 'w', encoding='utf-8') as f:
                f.write("")
            logging.info(f"Contenido de '{os.path.basename(ruta_txt)}' vaciado.")
        except Exception as e:
            logging.error(f"Error al vaciar '{ruta_txt}': {e}")
    else:
        logging.info(f"Archivo '{os.path.basename(ruta_txt)}' no encontrado para vaciar.")

def main():
    base_path = os.path.join(os.getenv("APPDATA"), "AnyDesk")
    carpetas = ["chat", "msg_thumbnails", "thumbnails"]

    limpiar_carpetas(base_path, carpetas)
    eliminar_archivo(os.path.join(base_path, "ad.trace"))
    vaciar_txt(os.path.join(base_path, "connection_trace.txt"))
    renombrar_archivo(
        os.path.join(base_path, "service.conf"),
        os.path.join(base_path, "service.conf.old")
    )

if __name__ == "__main__":
    main()
