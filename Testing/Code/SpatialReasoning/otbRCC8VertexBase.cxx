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
#include "otbRCC8VertexBase.h"
#include "otbMacro.h"

int otbRCC8VertexBase(int argc, char* argv[])
{
try
  {
    typedef unsigned short LabelType;
    unsigned int imageIndex = atoi(argv[1]);
    LabelType objectLabel = static_cast<LabelType>(atof(argv[2]));
    typedef otb::RCC8VertexBase<LabelType> RCC8VertexType;
    typedef RCC8VertexType::AttributesMapType AttributesMapType;
    // Instantiation
    RCC8VertexType::Pointer vertex1= RCC8VertexType::New();
    // Getters / setters tests
    vertex1->SetSegmentationImageIndex(imageIndex);
    vertex1->SetObjectLabelInImage(objectLabel);
    otbControlConditionTestMacro(vertex1->GetSegmentationImageIndex()!=imageIndex,
				 "Test failed: vertex1->GetSegmentationImageIndex()!=imageIndex");
    otbControlConditionTestMacro( vertex1->GetObjectLabelInImage()!=objectLabel,
				  "Test failed: vertex1->GetSegmentationImageIndex()!=imageIndex");
    // attributes vector set test
    AttributesMapType attr1 = vertex1->GetAttributesMap(); 
    otbControlConditionTestMacro( attr1["SegmentationImageIndex"].compare(std::string(argv[1]))!=0,
				  "Test failed: vertex1->GetAttributesMap()[\"SegmentationImageIndex\"]!=std::string(argv[1])");
    otbControlConditionTestMacro(attr1["ObjectLabelInImage"].compare(std::string(argv[2]))!=0,
				 "Test failed: vertex1->GetAttributesMap()[\"ObjectLabelInImage\"]!=std::string(argv[2])");
    // attributes vector get test
    RCC8VertexType::Pointer vertex2 = RCC8VertexType::New();
    vertex2->SetAttributesMap(attr1);
    otbControlConditionTestMacro(vertex1->GetSegmentationImageIndex()!=vertex2->GetSegmentationImageIndex(),
				 "Test failed: vertex1->GetSegmentationImageIndex()!=vertex2->GetSegmentationImageIndex()");

    otbControlConditionTestMacro(vertex1->GetObjectLabelInImage()!=vertex2->GetObjectLabelInImage(),
				 "Test failed: vertex1->GetObjectLabelInImage()!=vertex2->GetObjectLabelInImage()");
  }
catch( itk::ExceptionObject & err ) 
  { 
    std::cout << "Exception itk::ExceptionObject thrown !" << std::endl; 
    std::cout << err << std::endl; 
    return EXIT_FAILURE;
  } 
catch( ... ) 
  { 
    std::cout << "Unknown exception thrown !" << std::endl; 
    return EXIT_FAILURE;
  } 
 return EXIT_SUCCESS;
}
