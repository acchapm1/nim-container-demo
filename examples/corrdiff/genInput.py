from datetime import datetime, timedelta
import numpy as np
import torch
from earth2studio.data import GEFS_FX, GEFS_FX_721x1440

GEFS_SELECT_VARIABLES = [
    "u10m", "v10m", "t2m", "r2m", "sp", "msl", "tcwv"
]
GEFS_VARIABLES = [
    "u1000", "u925", "u850", "u700", "u500", "u250", "v1000", "v925", "v850",
    "v700", "v500", "v250", "z1000", "z925", "z850", "z700", "z500", "z200",
    "t1000", "t925", "t850", "t700", "t500", "t100", "r1000", "r925", "r850",
    "r700", "r500", "r100"
]

ds_gefs = GEFS_FX(cache=True)
ds_gefs_select = GEFS_FX_721x1440(cache=True, product="gec00")

def fetch_input_gefs(time: datetime, lead_time: timedelta, content_dtype: str = "float32"):
    dtype = np.dtype(getattr(np, content_dtype))
    # Fetch high-res select GEFS input data
    select_data = ds_gefs_select(time, lead_time, GEFS_SELECT_VARIABLES).values
    select_data = select_data[:, 0, :, 148:277, 900:1201].astype(dtype)
    # Fetch GEFS input data and interpolate
    pressure_data = ds_gefs(time, lead_time, GEFS_VARIABLES).values
    pressure_data = torch.nn.functional.interpolate(
        torch.Tensor(pressure_data),
        (len(GEFS_VARIABLES), 721, 1440),
        mode="nearest"
    ).numpy()
    pressure_data = pressure_data[:, 0, :, 148:277, 900:1201].astype(dtype)
    # Create lead time field
    lead_hour = int(lead_time.total_seconds() // (3 * 60 * 60)) * np.ones((1, 1, 129, 301)).astype(dtype)
    input_data = np.concatenate([select_data, pressure_data, lead_hour], axis=1)[None]
    return input_data

input_array = fetch_input_gefs(datetime(2023, 1, 1), timedelta(hours=0))
np.save("corrdiff_inputs.npy", input_array)

