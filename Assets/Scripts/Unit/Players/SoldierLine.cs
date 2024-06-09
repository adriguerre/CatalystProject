using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Jobs;

public class SoldierLine : MonoBehaviour
{

    [SerializeField] private GameObject soldier;
    [SerializeField] private float moveSpeed = 5;
    
    [Header("Line Renderer Properties")]
    [SerializeField] private float minDistance = 0.1f;
    [SerializeField] private LayerMask groundLayer;
    [SerializeField] private LayerMask obstacleLayer;
    public LineRenderer line;
    private Vector3 previousPosition;
    
    [Header("Movement Properties")]
    [SerializeField] private Vector3[] newPos;
    [SerializeField] private Vector3 lastPosition;
    private int moveIndex = 0;
    public bool alreadyDraw = false;
    private bool isMoving = false;
    
    /// <summary>
    /// Events
    /// </summary>
    public event EventHandler onStartedMoving;
    public event EventHandler onStoppedMoving;
    void Start()
    {
        line = GetComponent<LineRenderer>();
        previousPosition = transform.position;
    }
    
    void Update()
    {
        if (line.positionCount >= 10)
        {
            onStartedMoving?.Invoke(this, EventArgs.Empty);
            newPos = new Vector3[line.positionCount];
            line.GetPositions(newPos);
            Vector3 currentPosition = newPos[moveIndex];
            soldier.transform.position = Vector3.MoveTowards(soldier.transform.position, currentPosition, moveSpeed * Time.deltaTime);
            //Rotation 
            float rotateSpeed = 10f;
            Vector3 moveDirection = (currentPosition - soldier.transform.position).normalized;
            soldier.transform.forward = Vector3.Lerp(soldier.transform.forward, moveDirection, Time.deltaTime * rotateSpeed);
            
            float distance = Vector3.Distance(currentPosition, soldier.transform.position);
            if (distance <= 0.05f)
            {
                moveIndex++;
            }
            if (moveIndex > newPos.Length - 1)
            {
                isMoving = false;
                line.positionCount = 0;
                moveIndex = 0;
                onStoppedMoving?.Invoke(this, EventArgs.Empty);
            }
        }
    }
    public void DrawMovementLine()
    {
        if (isMoving)
        {
            isMoving = false; 
            line.positionCount = 0;
            moveIndex = 0;
        }
        Vector3 currentPosition = new Vector3(0, 0, 0);
        if (Input.GetMouseButton(0))
        {
            //Si en algun momento esto se rompe porque ponemos mas camaras, deberemos de refenciar a la main camera
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            if (Physics.Raycast(ray, out RaycastHit raycastHitObstcle, float.MaxValue, obstacleLayer))
            {
                /*Vector3 mousePosition = Input.mousePosition;
                mousePosition.z = _cameraPlane;
                mousePosition = _camera.ScreenToWorldPoint(mousePosition);

                Vector3 offset = mousePosition - transform.position;
                Vector3 direction = offset.normalized;
                float maxDistance = Mathf.Min(offset.magnitude, maxSpeed * Time.deltaTime);
                
                
                offset = hit.point + radius * hit.normal - transform.position;                
                float distance = Vector3.Dot(offset, direction) - 0.001f;
                targetPosition = transform.position + direction * distance;

                transform.position = targetPosition;

                if (i + 1 == limit)
                    return;

                // Determine a new move to approach the cursor without
                // penetrating deeper into whatever we hit.
                maxDistance = Mathf.Max(maxDistance - distance, 0f);

                offset = mousePosition - transform.position;    

                // Make sure we don't overshoot the closest point on this line
                // to the mouse (prevents vibrating when close-but-mot-quite).
                distance = offset.sqrMagnitude;
                float forbidden = Vector3.Dot(offset, hit.normal);
                distance -= forbidden * forbidden;
                // Shouldn't happen with infinite-precision real numbers, 
                // but rounding errors happen in practice.
                if (distance < 0f) 
                    return;    
                maxDistance = Mathf.Min(maxDistance, Mathf.Sqrt(distance));                            

                // Calculate new movement direction.
                offset -= forbidden * hit.normal;
                offset.y = 0f;
                direction = offset.normalized;

                targetPosition = transform.position + direction * maxDistance;
                */
              
            } else if (Physics.Raycast(ray, out RaycastHit raycastHit, float.MaxValue, groundLayer))
            {
                
              //  Debug.Log(raycastHit.point);
               // Debug.Log("GROUND GROUND");
                currentPosition = raycastHit.point;
            }
            else
            {
                Debug.Log("NOTHING");
            }
            if (Vector3.Distance(currentPosition, previousPosition) > minDistance)
            {
                line.positionCount++;
                line.SetPosition(line.positionCount- 1, currentPosition);
                previousPosition = currentPosition;
            }
            
        }
    }

    public void RemovePositions()
    {
        line.positionCount = 0;
    }

    public void StartMovingFollowingTheLine()
    {
        newPos = new Vector3[line.positionCount];
        line.GetPositions(newPos);
        isMoving = true;
        //soldier.transform.LookAt(newPos[newPos.Length - 1]);
        //soldier.transform.Translate(Vector3.forward * moveSpeed * Time.deltaTime);
    }


    public bool GetMoveEnded()
    {
        return isMoving;
    }
}
