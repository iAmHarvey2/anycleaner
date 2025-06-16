import os
import time
import win32serviceutil
import win32service
import win32event
import servicemanager
import shutil

class AnyCleanerService(win32serviceutil.ServiceFramework):
    _svc_name_ = "AnyCleanerService"
    _svc_display_name_ = "AnyDesk Cleaner Service"
    _svc_description_ = "Limpia automáticamente archivos temporales de AnyDesk al inicio."

    def __init__(self, args):
        super().__init__(args)
        self.hWaitStop = win32event.CreateEvent(None, 0, 0, None)

    def SvcStop(self):
        self.ReportServiceStatus(win32service.SERVICE_STOP_PENDING)
        win32event.SetEvent(self.hWaitStop)

    def SvcDoRun(self):
        servicemanager.LogInfoMsg("AnyCleanerService iniciado.")
        self.clean_anydesk()
        servicemanager.LogInfoMsg("AnyCleanerService completado.")
        # Finaliza después de una sola ejecución
        self.SvcStop()

    def clean_anydesk(self):
        base_path = os.path.join(os.getenv("APPDATA"), "AnyDesk")
        folders = ["chat", "msg_thumbnails", "thumbnails"]

        for folder in folders:
            full_path = os.path.join(base_path, folder)
            if os.path.exists(full_path):
                for item in os.listdir(full_path):
                    item_path = os.path.join(full_path, item)
                    try:
                        if os.path.isfile(item_path) or os.path.islink(item_path):
                            os.remove(item_path)
                        elif os.path.isdir(item_path):
                            shutil.rmtree(item_path)
                    except Exception as e:
                        servicemanager.LogErrorMsg(f"Error eliminando {item_path}: {str(e)}")

        trace_file = os.path.join(base_path, "ad.trace")
        if os.path.exists(trace_file):
            try:
                os.remove(trace_file)
            except Exception as e:
                servicemanager.LogErrorMsg(f"Error eliminando ad.trace: {str(e)}")

        conf_file = os.path.join(base_path, "service.conf")
        old_conf_file = os.path.join(base_path, "service.conf.old")
        if os.path.exists(conf_file):
            try:
                os.replace(conf_file, old_conf_file)
            except Exception as e:
                servicemanager.LogErrorMsg(f"Error renombrando service.conf: {str(e)}")

        connection_trace = os.path.join(base_path, "connection_trace.txt")
        if os.path.exists(connection_trace):
            try:
                open(connection_trace, 'w').close()
            except Exception as e:
                servicemanager.LogErrorMsg(f"Error limpiando connection_trace.txt: {str(e)}")
