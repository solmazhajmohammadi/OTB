/*=========================================================================

  Program:   ORFEO Toolbox
  Language:  C++
  Date:      $Date$
  Version:   $Revision$


  Copyright (c) Centre National d'Etudes Spatiales. All rights reserved.
  See OTBCopyright.txt for details.


     This software is distributed WITHOUT ANY WARRANTY; without even
     the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
     PURPOSE.  See the above copyright notices for more information.

=========================================================================*/
#include "itkExceptionObject.h"
#include "otbVectorDataProjectionFilter.h"
#include "otbVectorData.h"
#include "otbVectorDataFileReader.h"
#include "otbVectorDataFileWriter.h"


int otbVectorDataProjectionFilter(int argc, char * argv[])
{


  typedef otb::VectorData<double > InputVectorDataType;
  typedef otb::VectorData<double > OutputVectorDataType;


  typedef otb::VectorDataFileReader<InputVectorDataType> VectorDataFileReaderType;
  VectorDataFileReaderType::Pointer reader = VectorDataFileReaderType::New();

  reader->SetFileName(argv[1]);
  reader->Update();



  typedef otb::VectorDataProjectionFilter<InputVectorDataType,OutputVectorDataType> VectorDataFilterType;

  VectorDataFilterType::Pointer vectorDataProjection = VectorDataFilterType::New();

  vectorDataProjection->SetInput(reader->GetOutput());


  std::string projectionRefWkt ="PROJCS[\"UTM Zone 31, Northern Hemisphere\",GEOGCS[\"WGS 84\",DATUM[\"WGS_1984\",SPHEROID[\"WGS 84\",6378137,298.257223563,AUTHORITY[\"EPSG\",\"7030\"]],TOWGS84[0,0,0,0,0,0,0],AUTHORITY[\"EPSG\",\"6326\"]],PRIMEM[\"Greenwich\",0,AUTHORITY[\"EPSG\",\"8901\"]],UNIT[\"degree\",0.0174532925199433,AUTHORITY[\"EPSG\",\"9108\"]],AXIS[\"Lat\",NORTH],AXIS[\"Long\",EAST],AUTHORITY[\"EPSG\",\"4326\"]],PROJECTION[\"Transverse_Mercator\"],PARAMETER[\"latitude_of_origin\",0],PARAMETER[\"central_meridian\",3],PARAMETER[\"scale_factor\",0.9996],PARAMETER[\"false_easting\",500000],PARAMETER[\"false_northing\",0],UNIT[\"Meter\",1]]";

  vectorDataProjection->SetOutputProjectionRef(projectionRefWkt);

  typedef otb::VectorDataFileWriter<OutputVectorDataType> VectorDataFileWriterType;
  VectorDataFileWriterType::Pointer writer = VectorDataFileWriterType::New();
  writer->SetFileName(argv[2]);
  writer->SetInput(vectorDataProjection->GetOutput());
  writer->Update();


  return EXIT_SUCCESS;
}


