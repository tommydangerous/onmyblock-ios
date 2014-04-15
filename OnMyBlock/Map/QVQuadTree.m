//
//  QVQuadTree.m
//  MapCluster
//
//  Created by Tommy DANGerous on 4/14/14.
//  Copyright (c) 2014 Quantum Ventures. All rights reserved.
//

#import "QVQuadTree.h"

#pragma mark - Constructors

QVQuadTreeNodeData QVQuadTreeNodeDataMake(double x, double y, void *data)
{
  QVQuadTreeNodeData d;
  d.x    = x;
  d.y    = y;
  d.data = data;
  return d;
}

QVBoundingBox QVBoundingBoxMake(double x0, double y0, double xf, double yf)
{
  QVBoundingBox bb;
  bb.x0 = x0;
  bb.y0 = y0;
  bb.xf = xf;
  bb.yf = yf;
  return bb;
}

QVQuadTreeNode *QVQuadTreeNodeMake(QVBoundingBox boundary, int bucketCapacity)
{
  QVQuadTreeNode *node = malloc(sizeof(QVQuadTreeNode));
  node->northWest = NULL;
  node->northEast = NULL;
  node->southWest = NULL;
  node->southEast = NULL;

  node->boundingBox    = boundary;
  node->bucketCapacity = bucketCapacity;
  node->count          = 0;
  node->points         = malloc(sizeof(QVQuadTreeNodeData) * bucketCapacity);

  return node;
}

#pragma mark - Bounding Box Functions

bool QVBoundingBoxContainsData (QVBoundingBox box, QVQuadTreeNodeData data)
{
  bool containsX = box.x0 <= data.x && data.x <= box.xf;
  bool containsY = box.y0 <= data.y && data.y <= box.yf;

  return containsX && containsY;
}

bool QVBoundingBoxIntersectsBoundingBox (QVBoundingBox b1, QVBoundingBox b2)
{
  return (b1.x0 <= b2.xf && b1.xf >= b2.x0 && b1.y0 <= b2.yf && b1.yf >= b2.y0);
}

#pragma mark - Quad Tree Functions

void QVQuadTreeNodeSubdivide (QVQuadTreeNode *node)
{
  QVBoundingBox box = node->boundingBox;

  double xMid = (box.xf + box.x0) / 2.0;
  double yMid = (box.yf + box.y0) / 2.0;

  QVBoundingBox northWest = QVBoundingBoxMake(box.x0, box.y0, xMid, yMid);
  node->northWest = QVQuadTreeNodeMake(northWest, node->bucketCapacity);

  QVBoundingBox northEast = QVBoundingBoxMake(xMid, box.y0, box.xf, yMid);
  node->northEast = QVQuadTreeNodeMake(northEast, node->bucketCapacity);

  QVBoundingBox southWest = QVBoundingBoxMake(box.x0, yMid, xMid, box.yf);
  node->southWest = QVQuadTreeNodeMake(southWest, node->bucketCapacity);

  QVBoundingBox southEast = QVBoundingBoxMake(xMid, yMid, box.xf, box.yf);
  node->southEast = QVQuadTreeNodeMake(southEast, node->bucketCapacity);
}

bool QVQuadTreeNodeInsertData (QVQuadTreeNode *node, QVQuadTreeNodeData data)
{
  // Bail if our coordinate is not in the boundingBox
  if (!QVBoundingBoxContainsData(node->boundingBox, data)) {
    return false;
  }

  // Add the coordinate to the points array
  if (node->count < node->bucketCapacity) {
    node->points[node->count++] = data;
    return true;
  }

  // Check to see if the current node is a leaf, if it is, split
  if (node->northWest == NULL) {
    QVQuadTreeNodeSubdivide(node);
  }

  // Traverse the tree
  if (QVQuadTreeNodeInsertData(node->northWest, data)) return true;
  if (QVQuadTreeNodeInsertData(node->northEast, data)) return true;
  if (QVQuadTreeNodeInsertData(node->southWest, data)) return true;
  if (QVQuadTreeNodeInsertData(node->southEast, data)) return true;

  return false;
}

void QVQuadTreeGatherDataInRange (QVQuadTreeNode *node, QVBoundingBox range,
  QVDataReturnBlock block)
{
  // Perform bounding box queries

  // If range is not contained in the node's bounding box then bail
  if (!QVBoundingBoxIntersectsBoundingBox(node->boundingBox, range)) {
    return;
  }

  for (int i = 0; i < node->count; i++) {
    // Gather point contained in range
    if (QVBoundingBoxContainsData(range, node->points[i])) {
      block(node->points[i]);
    }
  }

  // Bail if node is leaf
  if (node->northWest == NULL) {
    return;
  }

  // Otherwise traverse down the tree
  QVQuadTreeGatherDataInRange(node->northWest, range, block);
  QVQuadTreeGatherDataInRange(node->northEast, range, block);
  QVQuadTreeGatherDataInRange(node->southWest, range, block);
  QVQuadTreeGatherDataInRange(node->southEast, range, block);
}

void QVQuadTreeTraverse (QVQuadTreeNode *node, QVQuadTreeTraverseBlock block)
{
  block(node);

  if (node->northWest == NULL) {
    return;
  }

  QVQuadTreeTraverse(node->northWest, block);
  QVQuadTreeTraverse(node->northEast, block);
  QVQuadTreeTraverse(node->southWest, block);
  QVQuadTreeTraverse(node->southEast, block);
}

QVQuadTreeNode *QVQuadTreeBuildWithData (QVQuadTreeNodeData *data, int count,
  QVBoundingBox boundingBox, int capacity)
{
  QVQuadTreeNode *root = QVQuadTreeNodeMake(boundingBox, capacity);
  for (int i = 0; i < count; i++) {
    QVQuadTreeNodeInsertData(root, data[i]);
  }

  return root;
}

void QVFreeQuadTreeNode (QVQuadTreeNode *node)
{
  if (node->northWest != NULL) QVFreeQuadTreeNode(node->northWest);
  if (node->northEast != NULL) QVFreeQuadTreeNode(node->northEast);
  if (node->southWest != NULL) QVFreeQuadTreeNode(node->southWest);
  if (node->southEast != NULL) QVFreeQuadTreeNode(node->southEast);
}
