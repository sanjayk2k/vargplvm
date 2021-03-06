paramTransformPsi2 <-
function (kern, gKern)
{
    fhandle <- paste(kern$type, "KernExtractParam", sep = "") 
    params  <- do.call(fhandle, list(kern)) 

    if (length(kern$transforms) > 1)
    {
        for (i in 1:length(kern$transforms))
        {
            fhandle <- paste(kern$transforms[[i]]$type, "Transform", sep = "") 
            if (!("transformsettings" %in% names(kern$transforms[[i]])))
                gKern[kern$transforms[[i]]$index] <- gKern[kern$transforms[[i]]$index]*do.call(fhandle, list(params[kern$transforms[[i]]$index], "gradfact")) 
            else
                gKern[kern$transforms[[i]]$index] <- gKern[kern$transforms[[i]]$index]*do.call(fhandle, list(params[kern$transforms[[i]]$index], "gradfact", kern$transforms[[i]]$transformsettings)) 
        }
    } else {
        fhandle <- paste(kern$transforms[[1]]$type, "Transform", sep = "") 
        if (!("transformsettings" %in% names(kern$transforms[[1]])))
            gKern[kern$transforms[[1]]$index] <- gKern[kern$transforms[[1]]$index]*do.call(fhandle, list(params[kern$transforms[[1]]$index], "gradfact", matlabway = TRUE)) 
        else
            gKern[kern$transforms[[1]]$index] <- gKern[kern$transforms[[1]]$index]*do.call(fhandle, list(params[kern$transforms[[1]]$index], "gradfact", kern$transforms[[1]]$transformsettings)) 
    } 
    
return (gKern)
}
