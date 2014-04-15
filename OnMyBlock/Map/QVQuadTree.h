//
//  QVQuadTree.h
//  MapCluster
//
//  Created by Tommy DANGerous on 4/14/14.
//  Copyright (c) 2014 Quantum Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

// Holds the coordinate (latitude, longitude)
typedef struct QVQuadTreeNodeData {
  double x;
  double y;
  // Generic pointer and should be used to store whatever extra info
  // we may need
  void *data;
} QVQuadTreeNodeData;
QVQuadTreeNodeData QVQuadTreeNodeDataMake(double x, double y, void *data);

// Represents a rectangle defined like a range query ie
// xMin <= x <= xMax && yMin <= y <= yMax
typedef struct QVBoundingBox {
  double x0; double y0;
  double xf; double yf;
} QVBoundingBox;
QVBoundingBox QVBoundingBoxMake(double x0, double y0, double xf, double yf);

// Holds four pointers for each quadrant
typedef struct quadTreeNode {
  struct quadTreeNode *northWest;
  struct quadTreeNode *northEast;
  struct quadTreeNode *southWest;
  struct quadTreeNode *southEast;
  QVBoundingBox boundingBox;
  int bucketCapacity;
  QVQuadTreeNodeData *points;
  int count;
} QVQuadTreeNode;
QVQuadTreeNode *QVQuadTreeNodeMake(QVBoundingBox boundary, int bucketCapacity);

typedef void (^QVDataReturnBlock) (QVQuadTreeNodeData data);

void QVFreeQuadTreeNode (QVQuadTreeNode *node);

#pragma mark - Bounding Box Functions

bool QVBoundingBoxContainsData (QVBoundingBox box, QVQuadTreeNodeData data);
bool QVBoundingBoxIntersectsBoundingBox (QVBoundingBox b1, QVBoundingBox b2);

#pragma mark - Quad Tree Functions

typedef void (QVQuadTreeTraverseBlock) (QVQuadTreeNode *currentNode);
void QVQuadTreeTraverse (QVQuadTreeNode *node, QVQuadTreeTraverseBlock block);

typedef void (^QVDataReturnBlock) (QVQuadTreeNodeData data);
void QVQuadTreeGatherDataInRange (QVQuadTreeNode *node, QVBoundingBox range,
  QVDataReturnBlock block);

bool QVQuadTreeNodeInsertData (QVQuadTreeNode *node, QVQuadTreeNodeData data);
QVQuadTreeNode *QVQuadTreeBuildWithData (QVQuadTreeNodeData *data, int count,
  QVBoundingBox boundingBox, int capacity);
