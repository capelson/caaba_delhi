from netCDF4 import Dataset
import os
import time
from utils import *
WORKDIR = os.getcwd()

params = {}
params['temp'] = os.getenv['TEMP']
params['press'] = os.getenv['PRESS']
params['relhum'] = os.getenv['RH']
params['start_day'] = os.getenv['DAY']
params['level'] = os.getenv['LEVEL']
params['lat'] = os.getenv['LAT']
params['lon'] = os.getenv['LON']

levels_by_1km =  {7: 1,
 13: 2,
 17: 3,
 19: 4,
 21: 5,
 23: 6,
 25: 7,
 26: 8,
 27: 9,
 28: 10,
 29: 11,
 30: 12,
 31: 13,
 32: 14,
 33: 15,
 34: 16,
 35: 17,
 36: 18,
 37: 19,
 38: 20}

def run_caaba(input_params, levels_vs_kms=levels_by_1km):
    start_day = input_params['start_day']
    lat = input_params['lat']
    level = input_params['level']
    lon = input_params['lon']
    temp = input_params['temp']
    press = input_params['press']
    relhum = input_params['relhum']


    if levels_vs_kms[level] > 1:

        parse_nml(
            WORKDIR+"/templates/caaba_delhi_teplate.nml",
            WORKDIR+"/nml/caaba_delhi.nml",
            species_file="input/delhi_init_spec_default.nc",
            model_start_day=start_day,
            runtime_str="5 days",
            time_step="5 minutes",
            press=press,
            temp=temp,
            relhum=relhum,
            zmbl=1000,
            lat=lat,
            lon=lon
        )
    else:
        parse_nml(
            WORKDIR+"/templates/caaba_delhi_teplate.nml",
            WORKDIR+"/nml/caaba_delhi.nml",
            species_file="input/delhi_init_spec_default.nc",
            model_start_day=start_day, 
            runtime_str="5 days",
            time_step="5 minutes",
            press=101000,
            temp=292.03,
            relhum=0.670,
            zmbl=1000,
            lat=lat,
            lon=lon
        )


    dir_name = "LAT_{}_LON_{}_{}_{}km".format(lat, lon, get_month_by_ord_day(start_day), levels_vs_kms[level])
    print(dir_name)
    params = {
    'meccainifile':'delhi',
    'compile':'s',
    'nmlfile':'caaba_delhi.nml',
    'l_montecarlo':'False',
    'runcaaba':'y',
    'outputdir':dir_name,
    'l_caabaplot':'False'
    } 
    pass_param_to_ini_file(template_path=WORKDIR+"/templates/ini_template.ini",
                      output_file=WORKDIR+"/ini/caaba_delhi.ini", **params)
    
    #os.system("./xcaaba caaba_delhi.ini")

if __name__ == '__main__':
    run_caaba(params)