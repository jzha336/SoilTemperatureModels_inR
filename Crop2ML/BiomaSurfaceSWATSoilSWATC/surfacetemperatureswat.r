library(gsubfn)

model_surfacetemperatureswat <- function (GlobalSolarRadiation,
         SoilTemperatureByLayers,
         AirTemperatureMaximum,
         AirTemperatureMinimum,
         Albedo,
         AboveGroundBiomass,
         WaterEquivalentOfSnowPack){
    #'- Name: SurfaceTemperatureSWAT -Version: 001, -Time step: 1
    #'- Description:
    #'            * Title: SurfaceTemperatureSWAT model
    #'            * Authors: simone.bregaglio
    #'            * Reference: http://bioma.jrc.ec.europa.eu/ontology/JRC_MARS_biophysical_domain.owl
    #'            * Institution: University Of Milan
    #'            * ExtendedDescription: Strategy for the calculation of surface soil temperature with SWAT method. Reference: Neitsch,S.L., Arnold, J.G., Kiniry, J.R., Williams, J.R., King, K.W. Soil and Water Assessment Tool. Theoretical documentation. Version 2000. http://swatmodel.tamu.edu/media/1290/swat2000theory.pdf
    #'            * ShortDescription: Strategy for the calculation of surface soil temperature with SWAT method
    #'- inputs:
    #'            * name: GlobalSolarRadiation
    #'                          ** description : Daily global solar radiation
    #'                          ** inputtype : variable
    #'                          ** variablecategory : exogenous
    #'                          ** datatype : DOUBLE
    #'                          ** max : 50
    #'                          ** min : 0
    #'                          ** default : 15
    #'                          ** unit : Mj m-2 d-1
    #'            * name: SoilTemperatureByLayers
    #'                          ** description : Soil temperature of each layer
    #'                          ** inputtype : variable
    #'                          ** variablecategory : auxiliary
    #'                          ** datatype : DOUBLEARRAY
    #'                          ** len : 
    #'                          ** max : 60
    #'                          ** min : -60
    #'                          ** default : 15
    #'                          ** unit : 
    #'            * name: AirTemperatureMaximum
    #'                          ** description : Maximum daily air temperature
    #'                          ** inputtype : variable
    #'                          ** variablecategory : exogenous
    #'                          ** datatype : DOUBLE
    #'                          ** max : 60
    #'                          ** min : -40
    #'                          ** default : 15
    #'                          ** unit : 
    #'            * name: AirTemperatureMinimum
    #'                          ** description : Minimum daily air temperature
    #'                          ** inputtype : variable
    #'                          ** variablecategory : exogenous
    #'                          ** datatype : DOUBLE
    #'                          ** max : 50
    #'                          ** min : -60
    #'                          ** default : 5
    #'                          ** unit : 
    #'            * name: Albedo
    #'                          ** description : Albedo of soil
    #'                          ** inputtype : variable
    #'                          ** variablecategory : exogenous
    #'                          ** datatype : DOUBLE
    #'                          ** max : 1
    #'                          ** min : 0
    #'                          ** default : 0.2
    #'                          ** unit : unitless
    #'            * name: AboveGroundBiomass
    #'                          ** description : Above ground biomass
    #'                          ** inputtype : variable
    #'                          ** variablecategory : auxiliary
    #'                          ** datatype : DOUBLE
    #'                          ** max : 60
    #'                          ** min : 0
    #'                          ** default : 3
    #'                          ** unit : Kg ha-1
    #'            * name: WaterEquivalentOfSnowPack
    #'                          ** description : Water equivalent of snow pack
    #'                          ** inputtype : variable
    #'                          ** variablecategory : exogenous
    #'                          ** datatype : DOUBLE
    #'                          ** max : 1000
    #'                          ** min : 0
    #'                          ** default : 10
    #'                          ** unit : mm
    #'- outputs:
    #'            * name: SurfaceSoilTemperature
    #'                          ** description : Average surface soil temperature
    #'                          ** datatype : DOUBLE
    #'                          ** variablecategory : auxiliary
    #'                          ** max : 60
    #'                          ** min : -60
    #'                          ** unit : degC
    Tavg <- (AirTemperatureMaximum + AirTemperatureMinimum) / 2
    Hterm <- (GlobalSolarRadiation * (1 - Albedo) - 14) / 20
    Tbare <- Tavg +  (Hterm * (AirTemperatureMaximum - AirTemperatureMinimum) / 2)
    WeightingCover <- AboveGroundBiomass / (AboveGroundBiomass + exp(7.563 - (0.0001297 * AboveGroundBiomass)))
    WeightingSnow <- WaterEquivalentOfSnowPack / (WaterEquivalentOfSnowPack + exp(6.055 - (0.3002 * WaterEquivalentOfSnowPack)))
    WeightingActual <- max (WeightingCover, WeightingSnow)
    SurfaceSoilTemperature <- WeightingActual * SoilTemperatureByLayers[1] + ((1 - WeightingActual) * Tbare)
    return (SurfaceSoilTemperature)
}