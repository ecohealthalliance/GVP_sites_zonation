raster_template_1dg = raster(matrix(1, 180,360), c(-180, 180, -90, 90))
projection(raster_template_1dg) = CRS("+proj=longlat +datum=WGS84")

name_list <- paste(P("data/mammal_10km_world/"), list.files(P("data/mammal_10km_world/")), sep = "/")
mammal_10km <- stack(name_list)



stacklist <- unstack(raster_1dg)
mams_sub <- Filter(function(e){!all(values(e) == 0)}, stacklist)
mams_sub_stack <- stack(mams_sub)

saveRDS(mams_sub_stack, P('data/mams_1dg_stack.RDS'))