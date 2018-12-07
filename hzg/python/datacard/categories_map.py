
#this maps human readable category types to
#names in the ttree and a RooFit categories string

categories_map = {'det_based_4cat':
                  {'leafname':'r94cat',
                   'catstring':'r94cat[cat1=1,cat2=2,cat3=3,cat4=4]',
                   'categories':[1,2,3,4],
                   'bkg_models':{'RooBernstein':{1:4, #category:order
                                                 2:5,
                                                 3:5,
                                                 4:5}
                                 },
                   'signal_models':{'CBplusGaus':{} #same for each cat
                                    }
                   }
                  }

#returns the factory string(s) for the background model
def make_background_for_cat(cattype,cat,bkg_model):
    available_cats = categories_map[cattype]['categories']
    available_models = categories_map[cattype]['bkg_models']
    if cat in available_cats:
        if bkg_model in available_models:
            model_info = available_models[bkg_model]
            factory_string = []
            #RooBernstein Polynomial type background
            if bkg_model == 'RooBernstein':
                specialize = ''
                temp = '%s::background_model_cat_%i'\
                                    %(bkg_model,cat)
                temp += '(%s)'                
                nconsts = model_info[cat]
                pconsts = ['bkg_cat_%i_c%i[-10,10]'%(cat,i+1) \
                           for i in range(nconsts)]
                specialize += 'Mzg,{1.0,%s}'%(','.join(pconsts))
                factory_string.append(temp%specialize)
            return factory_string                
        else:
            raise Exception('model %s not in %s!'%(bkg_model,cattype))
    else:
        raise Exception('category %s not in %s!'%(cat,cattype))

#returns the factory string(s) for the signal model
def make_signal_for_cat(cattype,cat,sig_model,mass,sig_type):
    available_cats = categories_map[cattype]['categories']
    available_models = categories_map[cattype]['signal_models']
    if cat in available_cats:
        if sig_model in available_models:
            model_info = available_models[sig_model]
            factory_string = []
            #crystal ball plus gaussian
            if sig_model == 'CBplusGaus':
                mname = str(mass).replace('.','p')
                #crystal ball distribution
                cb_name = 'sig_cb_m%s_%s_cat%i'%(mname,sig_type,cat)
                cb_shape = 'RooCBShape::%s'%cb_name
                cb_shape += '(%s)'
                pargs = 'Mzg,%s'%(
                    ','.join(['m0_%s_%s_cat%i[%.3f,%.3f]'%(sig_type,
                                                           mname,
                                                           cat,
                                                           mass-5,
                                                           mass+5),
                              'sigCB_%s_%s_cat%i[%f,%f,%f]'%(sig_type,
                                                             mname,
                                                             cat,
                                                             1.5,
                                                             0.3,
                                                             20),
                              'alphCB_%s_%s_cat%i[%f,%f,%f]'%(sig_type,
                                                              mname,
                                                              cat,
                                                              1.0,
                                                              0.5,
                                                              10),
                              'nCB_%s_%s_cat%i[%f,%f,%f]'%(sig_type,
                                                           mname,
                                                           cat,
                                                           4,
                                                           0.5,
                                                           50)]) )
                cb_shape = cb_shape%pargs
                factory_string.append(cb_shape)
                #gaussian
                gaus_name  = 'sig_gaus_m%s_%s_cat%i'%(mname,sig_type,cat)
                gaus_shape = 'RooGaussian::%s'%gaus_name
                gaus_shape += '(%s)'
                pargs = 'Mzg,%s'%(
                    ','.join(['m0_%s_%s_cat%i'%(sig_type,mname,cat),
                              'Gsig_%s_%s_cat%i[%f,%f,%f]'%(sig_type,
                                                            mname,
                                                            cat,
                                                            2,
                                                            0.3,
                                                            20)])
                    )
                gaus_shape = gaus_shape%pargs
                factory_string.append(gaus_shape)
                #RooAddPdf
                sum_name  = 'signal_model_m%s_%s_cat%i'%(mname,sig_type,cat)
                sum_shape = 'SUM::%s'%sum_name
                sum_shape += '(%s)'
                pargs = ','.join(
                    [cb_name,
                     '*'.join(['fGaus_m%s_%s_cat%i[0.5,0,1]'%(sig_type,
                                                              mname,
                                                              cat),
                               gaus_name])])
                sum_shape = sum_shape%pargs
                factory_string.append(sum_shape)
            return factory_string                
        else:
            raise Exception('model %s not in %s!'%(bkg_model,cattype))
    else:
        raise Exception('category %s not in %s!'%(cat,cattype))
